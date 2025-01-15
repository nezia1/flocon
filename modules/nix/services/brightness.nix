{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.laptop.enable {
    hardware.brillo.enable = true;
  };
}
