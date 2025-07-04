{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    hj = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          lxmenu-data
          pcmanfm # builds with gtk3 by default, no need to override
          shared-mime-info
          file-roller
          ;
      };
    };

    services.gvfs.enable = true; # mount, trash, and other functionalities
  };
}
