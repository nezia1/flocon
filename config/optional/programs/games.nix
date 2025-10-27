{
  pkgs,
  inputs',
  ...
}: {
  hj = {
    packages = with pkgs; [
      mangohud
      bolt-launcher
      qbittorrent
      wowup-cf
      inputs'.nur.legacyPackages.repos.rogreat.faugus-launcher
    ];
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      protontricks.enable = true;
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
