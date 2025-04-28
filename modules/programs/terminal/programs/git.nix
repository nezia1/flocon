{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.home) signingKey;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj = {
      packages = with pkgs; [gh lazygit];
      rum = {
        programs.git = {
          enable = true;
          settings = {
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
            diff.colorMoved = "default";
            merge.conflictstyle = "diff3";
          };
        };
      };
    };
  };
}
