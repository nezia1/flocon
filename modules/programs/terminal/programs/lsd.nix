{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.vars.system) username;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hjem.users.${username} = {
      rum.programs.lsd = {
        enable = true;
      };
    };
  };
}
