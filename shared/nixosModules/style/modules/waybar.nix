{
  lib,
  lib',
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.waybar.style =
        lib'.generateGtkColors lib cfg.scheme.palette;
    }
  ];
}
