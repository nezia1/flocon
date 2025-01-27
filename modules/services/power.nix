{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.laptop.enable {
    services = {
      power-profiles-daemon.enable = true;

      # battery info
      upower.enable = true;
    };
  };
}
