{pkgs, ...}: {
  local.style = {
    enable = true;
    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
      hash = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
    };
  };
}
