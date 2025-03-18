{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    services.tailscale.enable = true;
    hjem.users.${username} = {
      packages = [pkgs.gns3-gui];
    };
  };
}
