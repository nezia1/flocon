{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  imports = [./zathura.nix];

  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.mpv.enable = true;
    home.packages = [
      pkgs.gnome-calculator
      pkgs.gthumb
      pkgs.spotify
      pkgs.stremio
      pkgs.tidal-hifi
      pkgs.celluloid
    ];
  };
}
