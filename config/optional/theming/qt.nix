{pkgs, ...}: let
  variant = "mocha";
  accent = "lavender";
  kvantumTheme = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
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
    ".config/Kvantum/kvantum.kvconfig".source = ini.generate "kvantum.kvconfig" {
      General.theme = "catppuccin-mocha-lavender";
    };

    # https://discourse.nixos.org/t/catppuccin-kvantum-not-working/43727/14
    ".config/Kvantum/catppuccin-${variant}-${accent}".source = "${kvantumTheme}/share/Kvantum/catppuccin-${variant}-${accent}";
  };
}
