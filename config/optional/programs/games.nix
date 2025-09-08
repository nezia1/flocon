{
  pkgs,
  inputs',
  ...
}: {
  hj = {
    packages = [
      pkgs.mangohud
      pkgs.bolt-launcher
      pkgs.qbittorrent
      inputs'.nur.legacyPackages.repos.rogreat.faugus-launcher
      pkgs.wowup-cf
    ];
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    coolercontrol.enable = true;
  };

  services.hardware.openrgb.enable = true;
}
