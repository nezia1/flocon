{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop != "none") {
    services.tailscale.enable = true;
    hj = {
      packages = [pkgs.gns3-gui];
    };
  };
}
