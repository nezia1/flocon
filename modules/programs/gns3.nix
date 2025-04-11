{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf (config.local.homeVars.desktop != "none") {
    services.tailscale.enable = true;
    hjem.users.${username} = {
      packages = [pkgs.gns3-gui];
    };
  };
}
