{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;

  toINI = lib.generators.toINI {};
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    hjem.users.${username} = {
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

    home-manager.users.${username}.systemd.user.services.gammastep = {
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
