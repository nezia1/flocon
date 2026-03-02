{pkgs, ...}: let
  discord = pkgs.discord;
in {
  config = {
    hj = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
    };
  };
}
