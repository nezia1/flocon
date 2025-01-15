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
in {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit =
        starshipTransient
        + ''
          set fish_greeting # Disable greeting
          fish_vi_key_bindings # Enable Vi mode

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
