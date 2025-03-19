{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.uutils-coreutils-noprefix];
    };
  };
}
