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
      packages = [pkgs.uutils-coreutils-noprefix];
    };
  };
}
