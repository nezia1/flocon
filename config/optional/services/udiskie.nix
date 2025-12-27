{pkgs, ...}: {
  services.udisks2.enable = true;

  systemd.user.services.udiskie = {
    description = "Automounter for udisks";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    path = [pkgs.xdg-utils];
    serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie -aN";
  };
}
