{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;

  toConf = attrs:
    concatStringsSep "\n"
    (lib.mapAttrsToList (option: value: "--${option}=\"${value}\"") attrs);
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj = {
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
