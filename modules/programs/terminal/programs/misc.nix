{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hjem.users.${username} = {
      packages = with pkgs; [
        # archives
        zip
        unzip
        unrar

        # utils
        fd
        file
        ripgrep
        yazi
      ];
    };
  };
}
