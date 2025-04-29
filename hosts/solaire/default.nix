{lib, ...}: let
  inherit (lib.lists) singleton;
in {
  imports = [./hardware-configuration.nix];

  local = {
    vars = {
      system = {
        hostName = "solaire";
        username = "nezia";
      };

      home = {
        fullName = "Anthony Rodriguez";
        email = "anthony@nezia.dev";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzs7SQH0Vjt9JHoXXmWy9fPU1I3rrRWV5magZFrI5al nezia@solaire";
        desktop = "Hyprland";
      };
    };

    profiles = {
      gaming.enable = true;
    };

    modules = {
      nvidia.enable = true;
    };

    style = {
      enable = true;
      wallpapers = singleton ../../assets/wallpapers/lucy-edgerunners-wallpaper.jpg;
      cursors.size = 24;
    };
  };
}
