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
      packages = with pkgs; [
        # archives
        zip
        unzip
        unrar

        # utils
        fd
        file
        ripgrep
        yazi
      ];
    };
  };
}
