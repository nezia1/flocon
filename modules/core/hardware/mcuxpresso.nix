{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    services.udev.packages = [inputs.self.packages.${pkgs.system}.mcuxpresso-udev];
  };
}
