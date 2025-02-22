{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
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
