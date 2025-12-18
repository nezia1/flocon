{pkgs, ...}: {
  systemd.user.services.swayidle = {
    description = "Idle Manager for Wayland";
    documentation = ["man:swayidle(1)"];
    wantedBy = ["sway-session.target"];
    partOf = ["graphical-session.target"];
    path = [pkgs.bash];
    serviceConfig = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w -d";
    };
  };
}
