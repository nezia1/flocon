{pkgs, ...}: {
  home.packages = [
    pkgs.mangohud
    pkgs.bolt-launcher
    pkgs.ankama-launcher
    pkgs.lutris
    pkgs.qbittorrent
  ];
}
