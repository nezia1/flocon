{pkgs, ...}: let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/wallpapers/nix-wallpaper-nineish-catppuccin-frappe-alt.svg";
    hash = "sha256-fd2s7fEi1lzrrbYtD5oxCWffVTsIWWlxB8jsbpnn16k=";
  };
in {
  local.style = {
    enable = true;
    wallpapers = [wallpaper];
  };
}
