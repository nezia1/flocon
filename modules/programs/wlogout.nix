{
  lib,
  pkgs,
  config,
  ...
}: let
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
    builtins.concatStringsSep "\n" (map formatItem items);
in {
  config = lib.mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
      packages = [pkgs.wlogout];
      files = {
        ".config/wlogout/layout".text = let
          loginctl = lib.getExe' pkgs.systemd "loginctl";
          systemctl = lib.getExe' pkgs.systemd "systemctl";
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
