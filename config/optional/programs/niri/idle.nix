{lib, ...}: let
  dms = "dms ipc call";
in {
  systemd.user.services.swayidle.path = lib.mkForce [];
  hj.xdg.config.files."swayidle/config".text = ''
    lock "${dms} lock lock"
    before-sleep "loginctl lock-session"

    timeout 600 "${dms} lock lock"
    timeout 1200 "niri msg action power-off-monitors"
  '';
}
