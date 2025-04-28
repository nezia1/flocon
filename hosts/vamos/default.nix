_: {
  imports = [./hardware-configuration.nix];

  local = {
    vars.system = {
      hostName = "vamos";
      username = "nezia";
    };

    vars.home = {
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
      cursorTheme.size = 32;
    };
  };
}
