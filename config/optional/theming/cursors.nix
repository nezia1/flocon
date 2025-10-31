{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (lib.gvariant) mkUint16;

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

    programs.dconf = {
      enable = true;
      profiles.user.databases = singleton {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = styleCfg.cursors.xcursor.name;
            cursor-size = mkUint16 styleCfg.cursors.size;
          };
        };
      };
    };
  };
}
