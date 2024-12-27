{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;

    settings = {
      preload = ["${config.local.style.wallpaper}"];
      wallpaper = [", ${config.local.style.wallpaper}"];
    };
  };

  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
  systemd.user.services.hyprpaper.Unit.Slice = "background-graphical.slice";
}
