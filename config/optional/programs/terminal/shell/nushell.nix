# simplified version of https://raw.githubusercontent.com/Lunarnovaa/nixconf/3d13d69e9fcf072365935ee9dda719d6b0aa9bc1/modules/programs/terminal/nushell.nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  carapaceCache = "${config.hj.directory}/.cache/carapace";
  starshipCache = "${config.hj.directory}/.cache/starship";
  zoxideCache = "${config.hj.directory}/.cache/zoxide";
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          carapace
          nushell
          ;
      };
      files = {
        ".config/nushell/config.nu".text = ''
          # disabling the basic banner on startup
          $env.config = {
            show_banner: false,
            edit_mode: vi,
            hooks: {
              pre_prompt: [{ ||
                if (which direnv | is-empty) {
                  return
                }

                direnv export json | from json | default {} | load-env
                if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
                  $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
                }
              }]
            }
          }
          $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"

          # remove indicator chars besides the one provided by starship
          $env.PROMPT_INDICATOR_VI_INSERT = ""
          $env.PROMPT_INDICATOR_VI_NORMAL = ""
          $env.PROMPT_MULTILINE_INDICATOR = "| "

          # aliases
          alias ll = ls -l
          alias lg = lazygit

          alias lg = lazygit;
          alias g = git;
          alias gs = git status;
          alias gsh = git show HEAD;
          alias gshs = DELTA_FEATURES=+side-by-side git show HEAD;
          alias ga = git add;
          alias gaa = git add :/;
          alias gap = git add -p;
          alias gc = git commit;
          alias gca = git commit --amend;
          alias gcm = git commit --message;
          alias gcf = git commit --fixup;
          alias gk = git checkout;
          alias gkp = git checkout -p;
          alias gd = git diff;
          alias gds = DELTA_FEATURES=+side-by-side git diff;
          alias gdc = git diff --cached;
          alias gdcs = DELTA_FEATURES=+side-by-side git diff --cached;
          alias gf = git fetch;
          alias gl = git log;
          alias glp = git log -p;
          alias glps = DELTA_FEATURES=+side-by-side git log -p;
          alias gp = git push;
          alias gpf = git push --force-with-lease;
          alias gr = git reset;
          alias gra = git reset :/;
          alias grp = git reset -p;
          alias gt = git stash;
          alias gtp = git stash pop;
          alias gu = git pull;

          # carapace init (completion engine)
          source ${carapaceCache}/init.nu
          # starship init
          use ${starshipCache}/init.nu
          # zoxide init
          source ${zoxideCache}/init.nu
        '';

        ".config/nushell/env.nu".text = ''
          mkdir ${carapaceCache}
          mkdir ${starshipCache}
          mkdir ${zoxideCache}

          carapace _carapace nushell | save -f ${carapaceCache}/init.nu
          starship init nu | save -f ${starshipCache}/init.nu
          zoxide init nushell | save -f ${zoxideCache}/init.nu
        '';
      };
    };
  };
}
