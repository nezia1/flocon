{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      (nerdfonts.override {fonts = ["IntelOneMono"];})
    ];
    enableDefaultPackages = false;

    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Inter"];
      monospace = ["IntoneMono NF"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
