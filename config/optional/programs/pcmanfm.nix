{pkgs, ...}: {
  config = {
    hj = {
      packages = builtins.attrValues {
        inherit
          (pkgs.lxqt)
          pcmanfm-qt
          ;
        inherit
          (pkgs)
          lxmenu-data
          shared-mime-info
          file-roller
          ;
      };
    };

    services.gvfs.enable = true; # mount, trash, and other functionalities
  };
}
