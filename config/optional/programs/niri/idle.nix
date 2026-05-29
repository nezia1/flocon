{lib, ...}: let
  dms = "dms ipc call";
in {
  systemd.user.services.swayidle.path = lib.mkForce [];
  hj.xdg.config.files."swayidle/config".text = ''
    lock "${dms} lock lock"
    timeout 600 "loginctl lock-sessions"
    timeout 1200 "niri msg action power-off-monitors"
  '';
}
