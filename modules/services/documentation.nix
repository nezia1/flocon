{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    environment.systemPackages = [pkgs.man-pages pkgs.man-pages-posix];
    documentation = {
      enable = true;
      dev.enable = true;

      man = {
        enable = true;
        man-db.enable = false;
        mandoc.enable = true;
        generateCaches = true;
      };
    };
  };
}
