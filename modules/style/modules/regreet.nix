{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.programs.regreet = lib.mkIf cfg.enable {
    theme = {
      inherit (cfg.gtk.theme) name package;
    };

    cursorTheme = {
      inherit (cfg.cursorTheme) name package;
    };

    iconTheme = {
      inherit (cfg.gtk.iconTheme) name package;
    };
  };
}
