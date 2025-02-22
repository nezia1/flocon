{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.desktop.enable {
    services = {
      # setup printing service
      printing.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      printing.drivers = [
        pkgs.gutenprint
        pkgs.hplip
      ];

      udev.packages = [
        pkgs.sane-airscan
        pkgs.utsushi
      ];
    };

    hardware.sane.enable = true; # enables support for SANE scanners
    hardware.sane.extraBackends = [
      pkgs.sane-airscan # generic
      pkgs.hplip # HP
      pkgs.utsushi # other printers
    ];
  };
}
