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
    gnome-control-center
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

    inputs.neovim-flake.packages.${pkgs.system}.default
  ];
}
