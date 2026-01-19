{pkgs, ...}: let
  discord = pkgs.discord.override {
    withMoonlight = true;
    withOpenASAR = true;
  };
in {
  config = {
    hj = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
    };
  };
}
