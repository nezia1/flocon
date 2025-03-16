{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.homeVars) signingKey;
  inherit (config.local.systemVars) username;

  toINI = lib.generators.toINI {};
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = with pkgs; [git gh lazygit];
      files = {
        ".config/git/config".text = toINI {
          user = {
            name = "Anthony Rodriguez";
            email = "anthony@nezia.dev";
            signingkey = signingKey;
          };
          init.defaultBranch = "main";
          commit.gpgsign = true;
          tag.gpgsign = true;
          gpg.format = "ssh";
          push.autoSetupRemote = true;
          pull.rebase = true;
        };
      };
    };
  };
}
