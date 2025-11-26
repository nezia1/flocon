{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
  };
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
}
