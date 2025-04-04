{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) desktop;
in {
  config = mkIf desktop.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;
  };
}
