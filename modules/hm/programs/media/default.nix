{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  imports = [
    ./tidal-hifi.nix
    ./zathura.nix
  ];

  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.mpv.enable = true;
    home.packages = [
      pkgs.gnome-calculator
      pkgs.gthumb
      pkgs.spotify
      pkgs.stremio
      pkgs.celluloid
    ];
  };
}
