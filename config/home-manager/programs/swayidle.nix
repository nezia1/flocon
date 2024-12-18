{
  lib,
  config,
  ...
}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${lib.getExe config.programs.swaylock.package} --daemonize";
      }
      {
        event = "before-sleep";
        command = "${lib.getExe config.programs.swaylock.package} --daemonize";
      }
    ];
  };
  systemd.user.services.swayidle.Unit.After = lib.mkForce ["graphical-session.target"];
}
