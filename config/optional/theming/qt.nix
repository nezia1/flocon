{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.strings) toLower;
  # TODO: modularize when not lazy (taking inspo from https://github.com/rice-cracker-dev/rnc/blob/dd41577374eecf5655b69f554d3cf58474c4157f/modules/home/theme/qtct.nix)
  variant = "Mocha";
  accent = "lavender";

  kvantumTheme = pkgs.catppuccin-kvantum.override {
    inherit accent;
    variant = toLower variant;
  };

  qtctTheme = pkgs.catppuccin-qt5ct;

  qtctConf = {
    Appearance = {
      custom_palette = true;
      icon_theme = config.local.style.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum-dark";
      color_scheme_path = "${qtctTheme}/share/qt5ct/colors/Catppuccin-${variant}.conf";
    };

    Interface = {
      activate_item_on_single_click = 1;
      underline_shortcut = 1;
      wheel_scroll_lines = 3;
      menus_have_icons = true;
    };
  };

  ini = pkgs.formats.ini {};
in {
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  hj.packages = [
    qtctTheme
    kvantumTheme
  ];

  hj.files = {
    ".config/Kvantum/kvantum.kvconfig".source = ini.generate "kvantum-config" {
      General.theme = "catppuccin-mocha-lavender";
    };

    ".config/qt5ct/qt5ct.conf".source = ini.generate "qt5ct-config" qtctConf;
    ".config/qt6ct/qt6ct.conf".source = ini.generate "qt6ct-config" qtctConf;

    # https://discourse.nixos.org/t/catppuccin-kvantum-not-working/43727/14
    ".config/Kvantum/catppuccin-${toLower variant}-${accent}".source = "${kvantumTheme}/share/Kvantum/catppuccin-${toLower variant}-${accent}";
  };
}
