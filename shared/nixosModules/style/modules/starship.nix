{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.starship.settings = {
        directory = {
          style = "bold yellow";
        };
        character = {
          format = "$symbol ";
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
          vicmd_symbol = "[](bold green)";
        };
        cmd_duration = {
          style = "yellow";
          format = "[ $duration]($style)";
        };
      };
    }
  ];
}
