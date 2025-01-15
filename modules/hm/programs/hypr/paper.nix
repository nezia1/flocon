{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.default;

      settings = {
        preload = ["${osConfig.local.style.wallpaper}"];
        wallpaper = [", ${osConfig.local.style.wallpaper}"];
      };
    };

    systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
    systemd.user.services.hyprpaper.Service.Slice = "background-graphical.slice";
  };
}
