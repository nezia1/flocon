{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.profiles.laptop.enable && config.local.vars.home.desktop == "Hyprland") {
    hardware.brillo.enable = true;
  };
}
