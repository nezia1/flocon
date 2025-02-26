{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;

  toINI = lib.generators.toINI {};
in {
  config = mkIf config.local.profiles.desktop.enable {
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

      systemd.services.gammastep = {
        description = "Gammastep colour temperature adjuster";
        after = ["graphical-session.target"];
        wants = ["geoclue-agent.service"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.gammastep}/bin/gammastep-indicator";
          Restart = "on-failure";
          RestartSec = 3;
          Slice = "background-graphical.slice";
        };
      };
    };
  };
}
