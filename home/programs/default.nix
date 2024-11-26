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
    gnome-control-center
    playerctl
    nautilus
    simple-scan
    entr
    inputs.neovim-flake.packages.${pkgs.system}.default

    # https://nixpkgs-tracker.ocfox.me/?pr=357219
    # mission-center
    # cinny-desktop
  ];
}
