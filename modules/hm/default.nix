{
  lib,
  osConfig,
  ...
}: let
  styleCfg = osConfig.local.style;
in {
  imports = [
    ./programs
    ./services
  ];

  home.pointerCursor = lib.mkIf styleCfg.enable {
    inherit (styleCfg.cursorTheme) name package size;
    x11.enable = true;
    gtk.enable = true;
  };
}
