{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStrings;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.rum.programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        directory = {
          style = "bold yellow";
        };
        character = {
          format = "$symbol ";
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        cmd_duration = {
          style = "yellow";
          format = "[ $duration]($style)";
        };
        # https://github.com/llakala/nixos/blob/6e840f11d19e59b49e7ba9573f1398830799758a/apps/core/starship/git_status.nix
        git_status = {
          modified = "M";
          staged = "S";
          untracked = "A";
          renamed = "R";
          deleted = "D";
          conflicted = "U";

          ahead = "[+$count](green)";
          behind = "[-$count](red)";
          diverged = "[+$ahead_count](green),[-$behind_count](red)";

          style = "white";

          # referenced from https://github.com/clotodex/nix-config/blob/c878ff5d5ae674b49912387ea9253ce985cbd3cd/shell/starship.nix#L82
          format =
            concatStrings
            [
              "[("

              "(\\["
              "[($conflicted)](orange)"
              "[($stashed)](white)"
              "[($staged)](blue)"
              "[($deleted)](red)"
              "[($renamed)](yellow)"
              "[($modified)](yellow)"
              "[($untracked)](green)"
              "\\])"

              "( $ahead_behind)"

              " )]"
              "($style)"
            ];
        };
      };
    };
  };
}
