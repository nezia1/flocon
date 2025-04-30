{
  self',
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    services.udev.packages = [self'.packages.mcuxpresso-udev];
  };
}
