{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    fonts = {
      enableDefaultPackages = false;
      packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-extra
        pkgs.intel-one-mono
        pkgs.noto-fonts-color-emoji
        pkgs.nerd-fonts._0xproto
        pkgs.nerd-fonts.symbols-only
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Inter Medium"];
          monospace = ["0xProto Nerd Font"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
