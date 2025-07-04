{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj = {
      rum.programs.lsd = {
        enable = true;
      };
    };
  };
}
