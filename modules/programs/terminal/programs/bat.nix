{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;

  toConf = attrs:
    concatStringsSep "\n"
    (lib.mapAttrsToList (option: value: "--${option}=\"${value}\"") attrs);
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hjem.users.${username} = {
      packages = [
        pkgs.bat
        pkgs.bat-extras.batman
      ];
      files = {
        ".config/bat/config".text = toConf {
          theme = "base16";
        };
      };
    };
  };
}
