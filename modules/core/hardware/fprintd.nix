{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.laptop.enable {
    services.fprintd.enable = true;
  };
}
