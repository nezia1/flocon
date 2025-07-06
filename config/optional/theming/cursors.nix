{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  styleCfg = config.local.style;
in {
  config = mkIf styleCfg.enable {
    hj = {
      packages = [
        styleCfg.cursors.xcursor.package
        styleCfg.cursors.hyprcursor.package
      ];

      rum.misc.gtk.settings.cursor-theme-name = styleCfg.cursors.xcursor.name;

      environment.sessionVariables = {
        HYPRCURSOR_THEME = styleCfg.cursors.hyprcursor.name;
        HYPRCURSOR_SIZE = styleCfg.cursors.size;
        XCURSOR_THEME = styleCfg.cursors.xcursor.name;
        XCURSOR_SIZE = styleCfg.cursors.size;
        XCURSOR_PATH = "${styleCfg.cursors.xcursor.package}/share/icons";
      };
    };
  };
}
