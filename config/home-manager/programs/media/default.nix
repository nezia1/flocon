{pkgs, ...}: {
  imports = [./zathura.nix];
  programs.mpv.enable = true;
  home.packages = [
    pkgs.gnome-calculator
    pkgs.loupe
    pkgs.spotify
    pkgs.stremio
    pkgs.tidal-hifi
    pkgs.celluloid
  ];
}
