{
  lib,
  myLib,
  inputs',
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (myLib.generators) toHyprConf;

  inherit (inputs'.hypridle.packages) hypridle;

  hyprlock = getExe config.hj.rum.programs.hyprlock.package;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    hj = {
      packages = [hypridle];
      files = {
        ".config/hypr/hypridle.conf".text = toHyprConf {
          attrs = {
            general = {
              lock_cmd = "pidof ${hyprlock} || ${hyprlock}";
              unlock_cmd = "pkill --signal SIGUSR1 ${hyprlock}";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
              {
                timeout = 300; # 5m
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 330; # 5.5m
                on-timeout = "hyprctl dipsatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
              {
                timeout = 600; # 10m
                on-timeout = "systemctl suspend";
              }
            ];
          };
        };
      };
    };

    hm.systemd.user.services.hypridle = {
      Unit = {
        Name = "hypridle";
        After = ["graphical-session.target"];
        Description = "Hyprland's Idle Daemon";
      };

      Service = {
        Type = "simple";
        ExecStart = "${hypridle}/bin/hypridle";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
