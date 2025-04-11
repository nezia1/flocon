{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.homeVars.desktop != "none") {
    services.flatpak.enable = true;
  };
}
