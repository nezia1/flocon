{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = (mkIf (!config.local.profiles.server.enable)) {
    programs.ssh = {
      startAgent = true;
    };

    hj = {
      files = {
        ".ssh/config".text = ''
          AddKeysToAgent yes
        '';
      };
    };
  };
}
