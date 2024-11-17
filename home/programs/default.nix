{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./browsers
    ./media
    ./xdg.nix
    ./gtk.nix
    ./editors/helix.nix
  ];

  # idk where to put this
  programs = {
    fzf.enable = true;
    hyfetch.enable = true;
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # miscellaneous programs that do not need to be configured
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
    inputs.neovim-flake.packages.${pkgs.system}.default
  ];
}
