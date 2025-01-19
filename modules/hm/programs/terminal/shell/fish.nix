{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  starshipTransient = lib.strings.optionalString config.programs.starship.enableTransience ''
    function starship_transient_prompt_func
      starship module character
    end

    function starship_transient_rprompt_func
      starship module cmd_duration
    end
  '';
  styleCfg = osConfig.local.style;
in {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit =
        starshipTransient
        + ''
          set fish_greeting # Disable greeting
          fish_vi_key_bindings # Enable Vi mode

        ''
        + lib.optionalString styleCfg.enable
        ''
          set fish_cursor_default     block      blink
          set fish_cursor_insert      line       blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual      block

          set -x fish_color_autosuggestion      brblack
          set -x fish_color_cancel              -r
          set -x fish_color_command             brgreen
          set -x fish_color_comment             brmagenta
          set -x fish_color_cwd                 green
          set -x fish_color_cwd_root            red
          set -x fish_color_end                 brmagenta
          set -x fish_color_error               brred
          set -x fish_color_escape              brcyan
          set -x fish_color_history_current     --bold
          set -x fish_color_host                normal
          set -x fish_color_host_remote         yellow
          set -x fish_color_match               --background=brblue
          set -x fish_color_normal              normal
          set -x fish_color_operator            cyan
          set -x fish_color_param               brblue
          set -x fish_color_quote               yellow
          set -x fish_color_redirection         bryellow
          set -x fish_color_search_match        'bryellow' '--background=brblack'
          set -x fish_color_selection           'white' '--bold' '--background=brblack'
          set -x fish_color_status              red
          set -x fish_color_user                brgreen
          set -x fish_color_valid_path          --underline
          set -x fish_pager_color_completion    normal
          set -x fish_pager_color_description   yellow
          set -x fish_pager_color_prefix        'white' '--bold' '--underline'
          set -x fish_pager_color_progress      'brwhite' '--background=cyan'
        '';

      plugins = [
        {
          name = "fzf";
          inherit (pkgs.fishPlugins.fzf) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
      ];
    };

    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
