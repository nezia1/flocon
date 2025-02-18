{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) desktop;
  inherit (config.local.systemVars) username;
in {
  config = mkIf desktop.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d --keep 3";
      };
    };

    hjem.users.${username}.environment.sessionVariables.FLAKE = "/home/${username}/.dotfiles";
  };
}
