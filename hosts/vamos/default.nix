{pkgs, ...}: let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/wallpapers/nix-wallpaper-nineish-catppuccin-frappe-alt.svg";
    hash = "sha256-fd2s7fEi1lzrrbYtD5oxCWffVTsIWWlxB8jsbpnn16k=";
  };
in {
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
      wallpapers = [wallpaper];
    };
  };
}
