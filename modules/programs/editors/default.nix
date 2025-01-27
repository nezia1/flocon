{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
  inherit (config.local.homeVars) userEnvFile;
in {
  imports = [
    ./neovim.nix
  ];

  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      files = {
        ".config/environment.d/${userEnvFile}.conf".text = ''
          EDITOR="nvim";
        '';
      };
    };
  };
}
