{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  inherit (pkgs) swww;

  inherit (config.local.systemVars) username;

  updateWallpaper = pkgs.writeShellScript "wallpaper-change" ''
    sleep 0.1 && ${swww}/bin/swww img "$(${pkgs.coreutils}/bin/shuf -e ${concatStringsSep " " config.local.style.wallpapers} -n 1)"
  '';
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.systemd.services = {
      swww-daemon = {
        script = "${pkgs.swww}/bin/swww-daemon";
        description = "swww-daemon as systemd service";
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wants = ["swww-update-wallpaper.service"];

        serviceConfig.Slice = "background-graphical.slice";
      };
      swww-update-wallpaper = {
        script = "${updateWallpaper}";
        description = "Update wallpaper using SWWW";
        after = ["swww-daemon.service"];

        serviceConfig.Type = "oneshot";
      };
    };
  };
}
