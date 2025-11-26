{
  myLib,
  inputs',
  ...
}: let
  inherit (myLib.generators) toHyprConf;

  inherit (inputs'.hypridle.packages) hypridle;
in {
  hj = {
    packages = [hypridle];
    files = {
      ".config/hypr/hypridle.conf".text = toHyprConf {
        attrs = {
          general = {
            lock_cmd = "dms ipc call lock lock";
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
              on-timeout = "hyprctl dispatch dpms off";
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
}
