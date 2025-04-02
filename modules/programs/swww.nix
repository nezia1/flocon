{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  inherit (config.local.systemVars) username;
  inherit (inputs.swww.packages.${pkgs.system}) swww;

  updateWallpaper = pkgs.writeShellScript "update-wallpaper" ''
    ${swww}/bin/swww img "$(${pkgs.uutils-coreutils-noprefix}/bin/shuf -e ${concatStringsSep " " config.local.style.wallpapers} -n 1)"
  '';
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.systemd.services = {
      swww-daemon = {
        script = "${swww}/bin/swww-daemon --format xrgb --no-cache";
        description = "swww-daemon as systemd service";
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wants = ["swww-update-wallpaper.service"];
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig.Slice = "background-graphical.slice";
      };

      swww-update-wallpaper = {
        script = "${updateWallpaper}";
        description = "Update wallpaper using SWWW";
        after = ["swww-daemon.service"];
        requires = ["swww-daemon.service"];

        serviceConfig = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/sleep 1";
        };
      };
    };
  };
}
