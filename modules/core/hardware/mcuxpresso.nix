{
  flakePkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    services.udev.packages = [flakePkgs.self.mcuxpresso-udev];
  };
}
