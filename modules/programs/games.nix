{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.vars.system) username;
in {
  config = mkIf config.local.profiles.gaming.enable {
    hjem.users.${username} = {
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
