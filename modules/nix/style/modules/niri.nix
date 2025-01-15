{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.niri = {
        settings = {
          layout.focus-ring.active.color = cfg.scheme.palette.base0D;
          cursor = {
            inherit (cfg.cursorTheme) size;
            theme = cfg.cursorTheme.name;
          };
        };
      };
    }
  ];
}
