{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.strings) concatStringsSep;

  inherit (pkgs) swaybg;

  swaybgStart = pkgs.writeShellScript "swaybg-start" ''
    ${swaybg}/bin/swaybg -i "$(${pkgs.uutils-coreutils-noprefix}/bin/shuf -e ${concatStringsSep " " config.local.style.wallpapers} -n 1)"
  '';
in {
  hm.systemd.user.services = {
    swaybg = {
      Unit = {
        Description = "swaybg service";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Requires = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${swaybgStart}";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
