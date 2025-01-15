_: {
  imports = [./hardware-configuration.nix ./config/theme.nix ./config/nvidia.nix];

  local = {
    systemVars = {
      hostName = "solaire";
      username = "nezia";
    };
    homeVars = {
      fullName = "Anthony Rodriguez";
      email = "anthony@nezia.dev";
    };

    profiles = {
      desktop.enable = true;
      gaming.enable = true;
    };

    modules = {
      hyprland.enable = true;
    };
  };

  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
