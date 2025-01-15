{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    programs.wlogout = {
      enable = true;

      layout = let
        systemd = let
          systemd = lib.getExe' pkgs.systemd;
        in {
          loginctl = systemd "loginctl";
          systemctl = systemd "systemctl";
        };
      in [
        {
          action = "${systemd.loginctl} lock-session";
          keybind = "l";
          label = "lock";
          text = "Lock";
        }

        {
          action = "${systemd.systemctl} hibernate";
          keybind = "h";
          label = "hibernate";
          text = "Hibernate";
        }

        {
          action = "${
            systemd.loginctl
          } terminate-user ${
            config.home.username
          }";

          keybind = "q";
          label = "logout";
          text = "Logout";
        }

        {
          action = "${systemd.systemctl} poweroff";
          keybind = "p";
          label = "shutdown";
          text = "Shutdown";
        }

        {
          action = "${systemd.systemctl} suspend";
          keybind = "s";
          label = "suspend";
          text = "Suspend";
        }

        {
          action = "${systemd.systemctl} reboot";
          keybind = "r";
          label = "reboot";
          text = "Reboot";
        }
      ];
    };
  };
}
