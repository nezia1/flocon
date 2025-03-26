{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.systemVars) username;

  package = pkgs.easyeffects;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.easyeffects];
      systemd.services.easyeffects = {
        description = "Easyeffects daemon";
        requires = ["dbus.service"];
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target" "pipewire.service"];
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = "${package}/bin/easyeffects --gapplication-service";
          ExecStop = "${package}/bin/easyeffects --quit";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
