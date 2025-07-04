{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.name != null) {
    services.flatpak.enable = true;
  };
}
