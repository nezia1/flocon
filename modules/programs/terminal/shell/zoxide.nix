{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
  config = lib.mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.zoxide];
    };
  };
}
