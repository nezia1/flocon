{pkgs, ...}: {
  config = {
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
