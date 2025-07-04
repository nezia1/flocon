{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.vars.system) username;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    users.users.${username}.shell = pkgs.zsh;
  };
}
