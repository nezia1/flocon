_: {
  imports = [./hardware-configuration.nix ./config/theme.nix];

  local = {
    systemVars = {
      hostName = "vamos";
      username = "nezia";
    };

    homeVars = {
      fullName = "Anthony Rodriguez";
      email = "anthony@nezia.dev";
    };
  };

  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
