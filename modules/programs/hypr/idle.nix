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
  inherit (inputs.hypridle.packages.${pkgs.system}) hypridle;

  hyprlock = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
in {
  config = lib.mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
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
    # needed when using uwsm as the session manager
    systemd.user.services.hypridle = {
      name = "hypridle";
      after = ["graphical-session.target"];
      description = "Hyprland's Idle Daemon";
      wantedBy = ["graphical-session.target"];
      restartTriggers = ["${config.hjem.users.${username}.files.".config/hypr/hypridle.conf".text}"];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${hypridle}/bin/hypridle";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
