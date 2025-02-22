{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.gaming.enable {
    hardware.keyboard.qmk.enable = true;
    environment.systemPackages = with pkgs; [
      via
    ];
    services.udev.packages = [pkgs.via];
  };
}
