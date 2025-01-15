{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    programs.hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    };
  };
}
