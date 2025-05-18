{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  imports = [self.nixosModules.gcr-ssh-agent];
  config = (mkIf (!config.local.profiles.server.enable)) {
    services.gnome.gcr-ssh-agent.enable = true;
    hj = {
      files = {
        ".ssh/config".text = ''
          AddKeysToAgent yes
        '';
      };
    };
  };
}
