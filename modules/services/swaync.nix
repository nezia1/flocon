{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toFile toJSON;
  inherit (lib.modules) mkIf;
  inherit (config.local.vars.system) username;

  swaync = pkgs.swaynotificationcenter;
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
        ".config/swaync/style.css".source = pkgs.concatText "swaync-style.css" [
          "${swaync}/etc/xdg/swaync/style.css"
          (toFile
            "swaync-override.css"
            /*
            css
            */
            ''
              @define-color cc-bg alpha(@window_bg_color, 0.9);

              @define-color noti-border-color alpha(@window_bg_color, 1);
              @define-color noti-bg @popover_bg_color;

              .widget-dnd > switch {
                background: @noti-bg;
                font-size: initial;
                border-radius: 12px;
                border: 1px solid @noti-border-color;
                box-shadow: none;
              }

              .widget-dnd > switch:checked {
                background: @accent_color;
              }
            '')
        ];
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
          ExecStart = "${swaync}/bin/swaync";
          ExecReload = "${swaync}/bin/swaync-client --reload-config --reload-css";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };
      };
    };
  };
}
