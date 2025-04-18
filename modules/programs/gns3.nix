{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;
in {
  config = mkIf (config.local.vars.home.desktop != "none") {
    services.tailscale.enable = true;
    hjem.users.${username} = {
      packages = [pkgs.gns3-gui];
    };
  };
}
