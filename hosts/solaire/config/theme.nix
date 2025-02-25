{lib, ...}: let
  inherit (lib.lists) singleton;
in {
  local.style = {
    enable = true;
    wallpapers = singleton ../../../assets/wallpapers/lucy-edgerunners-wallpaper.jpg;
  };
}
