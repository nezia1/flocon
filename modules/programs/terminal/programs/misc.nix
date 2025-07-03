{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
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
