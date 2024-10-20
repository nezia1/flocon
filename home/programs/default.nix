{pkgs, ...}: {
  imports = [
    ./browsers
    ./media
    ./xdg.nix
    ./gtk.nix
  ];

  programs = {
    fzf.enable = true;
    hyfetch.enable = true;
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home.packages = with pkgs; [
    geary
    imhex
    logisim-evolution
    obsidian
    proton-pass
    vesktop
    wl-clipboard
    fractal
    cinny-desktop
    gnome-control-center
    mission-center
    playerctl
    nautilus
    simple-scan
    entr
  ];
}
