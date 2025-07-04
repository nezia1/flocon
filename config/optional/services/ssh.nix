{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = (mkIf (!config.local.profiles.server.enable)) {
    hj = {
      files = {
        ".ssh/config".text = ''
          AddKeysToAgent yes
        '';
      };
    };
  };
}
