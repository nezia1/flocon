{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep map;
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;

  mkLayout = items: let
    formatItem = item: ''
      {
          "label" : "${item.label}",
          "action" : "${item.action}", 
          "text" : "${item.text}",
          "keybind" : "${item.keybind}"
      }'';
  in
    concatStringsSep "\n" (map formatItem items);
in {
  config = mkIf (config.local.homeVars.desktop == "Hyprland") {
    hjem.users.${username} = {
      packages = [pkgs.wlogout];
      files = {
        ".config/wlogout/layout".text = let
          loginctl = getExe' pkgs.systemd "loginctl";
          systemctl = getExe' pkgs.systemd "systemctl";
        in
          mkLayout [
            {
              action = "${loginctl} lock-session";
              keybind = "l";
              label = "lock";
              text = "Lock";
            }

            {
              action = "${systemctl} hibernate";
              keybind = "h";
              label = "hibernate";
              text = "Hibernate";
            }

            {
              action = "${loginctl} terminate-user ${username}";

              keybind = "q";
              label = "logout";
              text = "Logout";
            }

            {
              action = "${systemctl} poweroff";
              keybind = "p";
              label = "shutdown";
              text = "Shutdown";
            }

            {
              action = "${systemctl} suspend";
              keybind = "s";
              label = "suspend";
              text = "Suspend";
            }

            {
              action = "${systemctl} reboot";
              keybind = "r";
              label = "reboot";
              text = "Reboot";
            }
          ];
      };
    };
  };
}
