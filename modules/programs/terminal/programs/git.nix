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
              inherit signingKey;
            };
            init.defaultBranch = "main";
            commit.gpgsign = true;
            tag.gpgsign = true;
            gpg.format = "ssh";
            push.autoSetupRemote = true;
            pull.rebase = true;
            diff.colorMoved = "default";
            rerere.enabled = true;
            merge = {
              ff = false;
              conflictstyle = "diff3";
            };

            # performance tweaks
            core.untrackedCache = true;
            core.fsmonitor = "${pkgs.rs-git-fsmonitor}/bin/rs-git-fsmonitor";
            index.threads = true;
          };
        };
      };
    };
  };
}
