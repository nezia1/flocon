{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;
in {
  config = (mkIf (!config.local.profiles.server.enable)) {
    programs.ssh = {
      startAgent = true;
    };

    hjem.users.${username} = {
      files = {
        ".ssh/config".text = ''
          AddKeysToAgent yes
        '';
      };
    };
  };
}
