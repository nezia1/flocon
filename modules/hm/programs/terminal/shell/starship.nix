{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        add_newline = true;

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
    };
  };
}
