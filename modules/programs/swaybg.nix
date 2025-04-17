{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  inherit (config.local.systemVars) username;

  inherit (pkgs) swaybg;

  swaybgStart = pkgs.writeShellScript "swaybg-start" ''
    ${swaybg}/bin/swaybg -i "$(${pkgs.uutils-coreutils-noprefix}/bin/shuf -e ${concatStringsSep " " config.local.style.wallpapers} -n 1)"
  '';
in {
  config = mkIf (config.local.homeVars.desktop == "Hyprland") {
    hjem.users.${username}.systemd.services = {
      swaybg = {
        script = "${swaybgStart}";
        description = "swaybg service";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        requires = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
      };
    };
  };
}
