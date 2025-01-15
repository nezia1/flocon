{
  config,
  lib,
  lib',
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      services.swaync.style = lib'.generateGtkColors lib cfg.scheme.palette;
    }
  ];
}
