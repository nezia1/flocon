{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  # miscellaneous programs that do not need to be configured
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    home.packages = with pkgs; [
      cinny-desktop
      entr
      fractal
      geary
      imhex
      logisim-evolution
      mission-center
      nautilus
      obsidian
      playerctl
      proton-pass
      simple-scan
      wl-clipboard
    ];

    programs = {
      fzf.enable = true;
      fastfetch.enable = true;
      hyfetch = {
        enable = true;
        settings = {
          preset = "nonbinary";
          mode = "rgb";
          backend = "fastfetch";
          color_align.mode = "horizontal";
        };
      };
    };
  };
}
