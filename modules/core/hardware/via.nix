{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (pkgs) via;
in {
  config = mkIf config.local.profiles.gaming.enable {
    hardware.keyboard.qmk.enable = true;
    environment.systemPackages = [via];
    services.udev.packages = [via];
  };
}
