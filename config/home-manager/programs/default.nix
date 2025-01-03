{pkgs, ...}: {
  imports = [
    ./browsers
    ./gnome
    ./media
    ./xdg.nix
    ./editors/helix.nix
    ./editors/neovim.nix
  ];

  # idk where to put this
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

  # miscellaneous programs that do not need to be configured
  home.packages = with pkgs; [
    cinny-desktop
    entr
    fractal
    geary
    gns3-gui
    gns3-server
    imhex
    logisim-evolution
    mission-center
    nautilus
    obsidian
    playerctl
    proton-pass
    simple-scan
    vesktop
    wl-clipboard
  ];
}
