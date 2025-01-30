{
  lib,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
  config = lib.mkIf config.local.profiles.desktop.enable {
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
