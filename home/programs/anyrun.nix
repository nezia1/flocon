{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = true;
    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.4;};
      width = {fraction = 0.3;};
      height = {fraction = 0.5;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";

      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.dictionary
        inputs.anyrun.packages.${pkgs.system}.rink
      ];
    };
    extraCss = ''
      #window {
        background: transparent;
      }
    '';
  };
}
