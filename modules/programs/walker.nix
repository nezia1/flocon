{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    hm.systemd.user.services.walker = {
      Unit = {
        Description = "Walker launcher service";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        Requires = ["graphical-session.target"];
        ConditionEnvironment = ["WAYLAND_DISPLAY"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
        Slice = "background-graphical.slice";
        Restart = "on-failure";
      };

      Install.WantedBy = ["graphical-session.target"];
    };

    hj = {
      # TODO: configure when not lazy
      packages = [pkgs.walker];
      files.".config/walker/walker.toml".source = pkgs.writers.writeTOML "walker.toml" {
        app_launch_prefix = "uwsm app -- ";
      };
    };
  };
}
