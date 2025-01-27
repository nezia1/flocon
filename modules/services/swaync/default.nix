{
  lib,
  pkgs,
  config,
  lib',
  ...
}: let
  inherit (builtins) toJSON;
  inherit (config.local.systemVars) username;
  inherit (lib') generateGtkColors;
in {
  config = lib.mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
      files = {
        ".config/swaync/config.json".text = toJSON {
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          control-center-layer = "top";
          layer-shell = true;
          cssPriority = "application";
          control-center-margin-top = 0;
          control-center-margin-bottom = 0;
          control-center-margin-right = 0;
          control-center-margin-left = 0;
          notification-2fa-action = true;
          notification-inline-replies = false;
          notification-icon-size = 64;
          notification-body-image-height = 100;
          notification-body-image-width = 200;
        };
        ".config/swaync/style.css".text = (generateGtkColors config.local.style.scheme.palette) + builtins.readFile ./style.css;
      };

      packages = [pkgs.swaynotificationcenter];
    };

    systemd.user.services.swaync = {
      description = "Swaync notification daemon";
      documentation = ["https://github.com/ErikReider/SwayNotificationCenter"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "on-failure";
        Type = "dbus";
      };
    };
  };
}
