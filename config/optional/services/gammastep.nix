{
  lib,
  pkgs,
  ...
}: let
  toINI = lib.generators.toINI {};
in {
  config = {
    hj = {
      packages = [pkgs.gammastep];
      files = {
        ".config/gammastep/config.ini".text = toINI {
          general = {
            location-provider = "geoclue2";
            temp-day = 5500;
            temp-night = 3700;
          };
        };
      };
    };

    hm.systemd.user.services.gammastep = {
      Unit = {
        Description = "Gammastep colour temperature adjuster";
        After = ["graphical-session.target"];
        Wants = ["geoclue-agent.service"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.gammastep}/bin/gammastep-indicator";
        Restart = "on-failure";
        RestartSec = 3;
        Slice = "background-graphical.slice";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
