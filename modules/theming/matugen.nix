{
  config,
  lib,
  inputs,
  inputs',
  ...
}: let
  inherit (builtins) head;
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) server;
in {
  imports = [inputs.matugen.nixosModules.default];
  config = mkIf (!server.enable) {
    hj.packages = [inputs'.matugen.packages.default];
    programs.matugen = {
      enable = true;
      wallpaper = head config.local.theme.wallpapers;
      variant = "dark";
      jsonFormat = "hex";
      palette = "default";
    };
  };
}
