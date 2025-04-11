{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.profiles.laptop.enable && config.local.homeVars.desktop == "Hyprland") {
    services = {
      power-profiles-daemon.enable = true;

      # battery info
      upower.enable = true;
    };
  };
}
