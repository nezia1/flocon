{
  lib,
  lib',
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib'.generators) toHyprConf;
  inherit (config.local.systemVars) username;
  inherit (config.local.style) wallpaper;
  inherit (inputs.hyprpaper.packages.${pkgs.system}) hyprpaper;
in {
  config = lib.mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
      packages = [hyprpaper];
      files = {
        ".config/hypr/hyprpaper.conf".text = toHyprConf {
          attrs = {
            preload = ["${wallpaper}"];
            wallpaper = [", ${wallpaper}"];
          };
        };
      };
    };

    systemd.user.services.hyprpaper = {
      name = "hyprpaper";
      after = ["graphical-session.target"];
      description = "Fast, IPC-controlled wallpaper utility for Hyprland.";
      documentation = ["https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/"];
      wantedBy = ["graphical-session.target"];
      restartTriggers = ["${config.hjem.users.${username}.files.".config/hypr/hyprpaper.conf".text}"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${hyprpaper}/bin/hyprpaper";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
