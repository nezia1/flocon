{
  lib,
  pkgs,
  config,
  lib',
  ...
}: let
  inherit (builtins) readFile toJSON;
  inherit (lib.strings) optionalString;

  inherit (lib.modules) mkIf;

  inherit (lib') generateGtkColors;

  inherit (config.local.vars.system) username;

  styleCfg = config.local.style;
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
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
        ".config/swaync/style.css".text =
          # TODO: this is not great, make this use gtk colors instead :/
          (
            optionalString styleCfg.enable
            (generateGtkColors styleCfg.colors.scheme.palette)
          )
          + readFile ./style.css;
      };

      packages = [pkgs.swaynotificationcenter];

      systemd.services.swaync = {
        description = "Swaync notification daemon";
        documentation = ["https://github.com/ErikReider/SwayNotificationCenter"];
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };
      };
    };
  };
}
