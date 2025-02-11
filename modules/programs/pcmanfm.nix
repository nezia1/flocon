{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        lxmenu-data
        pcmanfm
        shared-mime-info
      ];
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
  };
}
