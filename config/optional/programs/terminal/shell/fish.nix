{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;

  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep;

  inherit (pkgs) writeShellApplication;

  rbld = writeShellApplication {
    name = "rbld";
    runtimeInputs = attrValues {
      inherit
        (pkgs)
        nixos-rebuild-ng
        nix-output-monitor
        ;
    };
    text = ''
      sudo -v || exit
      nixos-rebuild \
        --sudo \
        --no-reexec \
        --log-format internal-json \
        --flake "$HOME/.config/flocon" "$@" |&
        nom --json || exit 1
    '';
  };
  zoxideCfg = config.hj.rum.programs.zoxide;
in {
  hj.packages = [rbld];
  programs.fish.enable = true;
  hj.rum.programs.fish = {
    enable = true;
    aliases = {
      ls = "lsd";

      lg = "lazygit";
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gca = "git commit --amend";
      gcm = "git commit --message";
      gk = "git checkout";
      gd = "git diff";
      gf = "git fetch";
      gl = "git log";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gr = "git reset";
      gt = "git stash";
      gtp = "git stash pop";
      gu = "git pull";

      man = "batman";
    };

    config =
      # fish
      ''
        ${getExe zoxideCfg.package} init fish ${concatStringsSep " " zoxideCfg.flags} | source

        # cannot use the abbrs option because of --position anywhere
        abbr -a --position anywhere -- --help '--help | bat -plhelp'
        abbr -a --position anywhere -- -h '-h | bat -plhelp'
      '';
    earlyConfigFiles = {
      theme =
        # fish
        ''
          set fish_color_autosuggestion brblack
          set fish_color_cancel -r
          set fish_color_command blue
          set fish_color_comment brblack
          set fish_color_cwd green
          set fish_color_cwd_root red
          set fish_color_end brblack
          set fish_color_error red
          set fish_color_escape yellow
          set fish_color_history_current --bold
          set fish_color_host normal
          set fish_color_host_remote yellow
          set fish_color_keyword blue
          # set  fish_color_match --background=brblue
          set fish_color_normal normal
          set fish_color_operator yellow
          set fish_color_option cyan
          set fish_color_param cyan
          set fish_color_quote green
          set fish_color_redirection magenta
          # set fish_color_search_match 'bryellow'  '--background=brblack'
          set fish_color_selection 'white'  '--bold'  '--background=brblack'
          # set  fish_color_status red
          # set  fish_color_user brgreen
          set fish_color_valid_path --underline
          set fish_pager_color_background
          set fish_pager_color_completion normal
          set fish_pager_color_description 'yellow'
          set fish_pager_color_prefix 'normal'  '--bold'  '--underline'
          set fish_pager_color_progress 'brwhite'  '--background=cyan'
          set fish_pager_color_secondary_background
          set fish_pager_color_secondary_completion
          set fish_pager_color_secondary_description
          set fish_pager_color_secondary_prefix
          set fish_pager_color_selected_background --background=brblack
          set fish_pager_color_selected_completion
          set fish_pager_color_selected_description
          set fish_pager_color_selected_prefix
        '';
    };
  };
}
