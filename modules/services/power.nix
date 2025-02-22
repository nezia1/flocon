{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.laptop.enable {
    services = {
      power-profiles-daemon.enable = true;

      # battery info
      upower.enable = true;
    };
  };
}
