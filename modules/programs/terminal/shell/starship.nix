{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
  toTOML = (pkgs.formats.toml {}).generate;
in {
  config = lib.mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.starship];
      files = {
        ".config/starship/config.toml".source = toTOML "starship config" {
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
        };
      };
    };
  };
}
