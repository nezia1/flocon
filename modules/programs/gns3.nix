{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop != null) {
    services.tailscale.enable = true;
    hj = {
      packages = [pkgs.gns3-gui];
    };
  };
}
