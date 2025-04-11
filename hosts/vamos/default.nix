_: {
  imports = [./hardware-configuration.nix];

  local = {
    systemVars = {
      hostName = "vamos";
      username = "nezia";
    };

    homeVars = {
      fullName = "Anthony Rodriguez";
      email = "anthony@nezia.dev";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKEPlN/GU9nJZPleA77HH5NA+6vyhhM84fTSjEwnEgq nezia@vamos";
      desktop = "Hyprland";
    };

    profiles = {
      laptop.enable = true;
    };

    style = {
      enable = true;
    };
  };
}
