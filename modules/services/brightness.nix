{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.profiles.laptop.enable && config.local.homeVars.desktop == "Hyprland") {
    hardware.brillo.enable = true;
  };
}
