{
  config,
  pkgs,
  ...
}: let
  variant = "mocha";
  accent = "lavender";
  kvantumTheme = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };

  qtctConf = {
    Appearance = {
      custom_palette = true;
      icon_theme = config.local.style.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum-dark";
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
    pkgs.catppuccin-qt5ct
    kvantumTheme
  ];

  hj.files = {
    ".config/Kvantum/kvantum.kvconfig".source = ini.generate "kvantum-config" {
      General.theme = "catppuccin-mocha-lavender";
    };

    ".config/qt5ct/qt5ct.conf".source = ini.generate "qt5ct-config" qtctConf;
    ".config/qt6ct/qt6ct.conf".source = ini.generate "qt6ct-config" qtctConf;

    # https://discourse.nixos.org/t/catppuccin-kvantum-not-working/43727/14
    ".config/Kvantum/catppuccin-${variant}-${accent}".source = "${kvantumTheme}/share/Kvantum/catppuccin-${variant}-${accent}";
  };
}
