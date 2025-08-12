{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  systemd.user.services.xwayland-satellite = {
    script = "${getExe pkgs.xwayland-satellite} :0";
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      NotifyAccess = "all";
      Restart = "on-failure";
    };
    unitConfig = {
      ConditionEnvironment = ["WAYLAND_DISPLAY"];
    };
    wantedBy = ["niri.service"];
  };
}
