{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
      flake = "${config.hjem.users.${username}.directory}/flocon";
    };
  };
}
