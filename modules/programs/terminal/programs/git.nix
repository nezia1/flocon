{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
  inherit (config.local.homeVars) signingKey;
  toINI = lib.generators.toINI {};
in {
  config = lib.mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = with pkgs; [git lazygit];
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
        };
      };
    };
  };
}
