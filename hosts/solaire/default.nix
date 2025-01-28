_: {
  imports = [./hardware-configuration.nix ./config/theme.nix];

  local = {
    systemVars = {
      hostName = "solaire";
      username = "nezia";
    };
    homeVars = {
      fullName = "Anthony Rodriguez";
      email = "anthony@nezia.dev";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzs7SQH0Vjt9JHoXXmWy9fPU1I3rrRWV5magZFrI5al nezia@solaire";
    };

    profiles = {
      desktop.enable = true;
      gaming.enable = true;
    };

    modules = {
      hyprland.enable = true;
      nvidia.enable = true;
    };
  };
}
