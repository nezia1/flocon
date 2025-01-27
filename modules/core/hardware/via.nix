{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.gaming.enable {
    hardware.keyboard.qmk.enable = true;
    environment.systemPackages = with pkgs; [
      via
    ];
    services.udev.packages = [pkgs.via];
  };
}
