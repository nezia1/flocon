{
  pkgs,
  config,
  ...
}: let
  inherit (config.local.vars.home) signingKey;
in {
  config = {
    hj = {
      files = {
        ".config/lazygit/config.yml".source = pkgs.writers.writeYAML "lazygit-config" {
          git = {
            overrideGpg = true;
          };
        };
      };
      packages = builtins.attrValues {
        inherit
          (pkgs)
          gh
          lazygit
          mergiraf
          difftastic
          ;
      };
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
              mergiraf = {
                name = "mergiraf";
                driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
              };
              ff = false;
              conflictstyle = "diff3";
            };
            diff.external = "difft diff";

            core = {
              attributesfile = "~/.gitattributes";
              untrackedCache = true;
              fsmonitor = "${pkgs.rs-git-fsmonitor}/bin/rs-git-fsmonitor";
            };
            index.threads = true;
          };
        };
      };
      files.".gitattributes".text = ''
        * merge=mergiraf
      '';
    };
  };
}
