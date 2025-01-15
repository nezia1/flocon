{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.laptop.enable {
    services.fprintd.enable = true;
  };
}
