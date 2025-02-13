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
        pkgs._0xproto
        pkgs.noto-fonts-color-emoji
        pkgs.nerd-fonts.symbols-only

        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-extra
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Inter Medium"];
          monospace = ["0xProto"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
