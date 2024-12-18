{osConfig, ...}: {
  imports = [
    ./services/udiskie.nix
    ./terminal
    ./programs
  ];
  home = rec {
    inherit (osConfig.local.systemVars) username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
