{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.local.profiles.gaming.enable {
    hj = {
      packages = [
        pkgs.mangohud
        pkgs.bolt-launcher
        pkgs.lutris
        pkgs.qbittorrent
      ];
    };

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
      coolercontrol = {
        enable = true;
        nvidiaSupport = true;
      };
    };

    services.hardware.openrgb.enable = true;
  };
}
