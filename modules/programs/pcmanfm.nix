{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.vars.system) username;
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    hjem.users.${username} = {
      packages = with pkgs; [
        lxmenu-data
        pcmanfm # builds with gtk3 by default, no need to override
        shared-mime-info
        file-roller
      ];
    };

    services.gvfs.enable = true; # mount, trash, and other functionalities
  };
}
