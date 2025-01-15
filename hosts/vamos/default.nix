_: {
  imports = [
    ./hardware-configuration.nix
    ./config/theme.nix
  ];

  local = {
    systemVars = {
      hostName = "vamos";
      username = "nezia";
    };

    homeVars = {
      fullName = "Anthony Rodriguez";
      email = "anthony@nezia.dev";
    };

    profiles = {
      desktop.enable = true;
      laptop.enable = true;
    };

    modules = {
      hyprland.enable = true;
    };
  };

  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
