{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) desktop;
in {
  config = mkIf desktop.enable {
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };
}
