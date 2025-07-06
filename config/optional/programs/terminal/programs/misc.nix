{pkgs, ...}: {
  config = {
    hj = {
      packages = builtins.attrValues {
        # archives
        inherit
          (pkgs)
          zip
          unzip
          unrar
          # utils
          fd
          file
          ripgrep
          yazi
          ;
      };
    };
  };
}
