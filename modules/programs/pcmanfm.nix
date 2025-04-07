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
        pcmanfm # builds with gtk3 by default, no need to override
        shared-mime-info
      ];
    };

    services.gvfs.enable = true; # mount, trash, and other functionalities
  };
}
