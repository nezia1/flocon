{
  imports = [
    ./services/udiskie.nix
    ./terminal
    ./programs
  ];
  home = {
    username = "nezia";
    homeDirectory = "/home/nezia";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
