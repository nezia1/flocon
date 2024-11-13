{pkgs, ...}: {
  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      intel-one-mono
    ];
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Inter Medium"];
        monospace = ["Intel One Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
