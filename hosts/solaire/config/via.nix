{pkgs, ...}: let
  inherit (pkgs) via;
in {
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [via];
  services.udev.packages = [via];
}
