{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.types) nullOr;

  mkQtctSettingsOption = version:
    mkOption {
      type = nullOr ini.type;
      description = ''
        qt${version}ct configuration that will be written to {file}`$HOME/.config/qt${version}ct/qt${version}ct.conf`.
      '';
      example = literalExpression ''
        Appearance = {
          custom_palette = true;
          icon_theme = "Adwaita";
          standard_dialogs = "xdgdesktopportal";
          style = "kvantum-dark";
          color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/Catppuccin-Mocha.conf";
        };

        Interface = {
          activate_item_on_single_click = 1;
          underline_shortcut = 1;
          wheel_scroll_lines = 3;
          menus_have_icons = true;
        };
      '';
    };

  ini = pkgs.formats.ini {};

  cfg = config.local.misc.qtct;
in {
  options.local.misc.qtct = {
    enable = mkEnableOption "qtct declarative configuration";
    qt5 = {
      settings = mkQtctSettingsOption "5";
    };
    qt6 = {
      settings = mkQtctSettingsOption "6";
    };
  };

  config = mkIf cfg.enable {
    files = {
      ".config/qt5ct/qt5ct.conf".source = mkIf (cfg.qt5.settings != null) (ini.generate "qt5ct-config" cfg.qt5.settings);
      ".config/qt6ct/qt6ct.conf".source = mkIf (cfg.qt6.settings != null) (ini.generate "qt6ct-config" cfg.qt6.settings);
    };
  };
}
