{
  imports = [
    ./fonts.nix
    ./home-manager.nix
  ];
  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
  };
}
