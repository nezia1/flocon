{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.gaming.enable {
    home.packages = [
      pkgs.mangohud
      pkgs.bolt-launcher
      pkgs.ankama-launcher
      pkgs.lutris
      pkgs.qbittorrent
      pkgs.protonplus
    ];
  };
}
