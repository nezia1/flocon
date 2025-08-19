{
  pkgs,
  config,
  self,
  ...
}: let
  # TODO: add global state for kvantum/qtct themes
  kvantumTheme = pkgs.catppuccin-kvantum.override {
    variant = "mocha";
    accent = "lavender";
  };
  qtctTheme = pkgs.catppuccin-qt5ct;
  qtctConf = {
    Appearance = {
      custom_palette = true;
      icon_theme = config.local.style.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum-dark";
      color_scheme_path = "${qtctTheme}/share/qt5ct/colors/Catppuccin-Mocha.conf";
    };

    Fonts = {
      fixed = ''"monospace,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      general = ''"sans-serif,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
    };

    Interface = {
      activate_item_on_single_click = 1;
      underline_shortcut = 1;
      wheel_scroll_lines = 3;
      menus_have_icons = true;
    };
  };
in {
  hjem.extraModules = [
    self.hjemModules.kvantum
    self.hjemModules.qtct
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  hj = {
    local.misc = {
      qtct = {
        enable = true;
        qt5.settings = qtctConf;
        qt6.settings = qtctConf;
      };
      kvantum = {
        enable = true;
        theme = {
          name = "catppuccin-mocha-lavender";
          package = kvantumTheme;
        };
      };
    };
  };
}
