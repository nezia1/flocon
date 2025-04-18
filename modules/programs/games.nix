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
        pkgs.protonplus
      ];
    };

    programs = {
      steam = {
        enable = true;
      };

      gamemode.enable = true;
      gamescope.enable = true;

      coolercontrol = {
        enable = true;
        nvidiaSupport = true;
      };
    };

    services.hardware.openrgb.enable = true;
  };
}
