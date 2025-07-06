{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;

  toConf = attrs:
    concatStringsSep "\n"
    (lib.mapAttrsToList (option: value: "--${option}=\"${value}\"") attrs);
in {
  config = {
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
