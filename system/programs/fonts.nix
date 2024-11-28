{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-extra
      pkgs.intel-one-mono
      pkgs.noto-fonts-color-emoji
      (pkgs.nerdfonts.override {fonts = ["0xProto" "NerdFontsSymbolsOnly"];})
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Inter Medium"];
        monospace = ["0xProto NF"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
