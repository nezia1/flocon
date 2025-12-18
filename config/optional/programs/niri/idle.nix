{config, ...}: let
  noctalia = "noctalia-shell ipc call";
in {
  systemd.user.services.swayidle.path = [config.services.noctalia-shell.package];
  hj.xdg.config.files."swayidle/config".text = ''
    lock "${noctalia} lockScreen lock"
    timeout 600 "${noctalia} lockScreen lock"
    timeout 1200 "niri msg action power-off-monitors"
  '';
}
