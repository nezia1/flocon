{pkgs, ...}: let
  discord = pkgs.vesktop.override {
    withTTS = false;
    withSystemVencord = true;
  };
in {
  config = {
    hj = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
    };
  };
}
