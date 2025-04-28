{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toFile toJSON;
  inherit (lib.modules) mkIf;

  swaync = pkgs.swaynotificationcenter;
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    hj = {
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
    };

    hm.systemd.user.services.swaync = {
      Unit = {
        Description = "Swaync notification daemon";
        Documentation = ["https://github.com/ErikReider/SwayNotificationCenter"];
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${swaync}/bin/swaync";
        ExecReload = "${swaync}/bin/swaync-client --reload-config --reload-css";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
