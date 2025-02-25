{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  updateWallpaper = pkgs.writeShellScript "wallpaper-change" ''
    ${swww}/bin/swww img "$(${pkgs.coreutils}/bin/shuf -e ${concatStringsSep " " config.local.style.wallpapers} -n 1)"
  '';

  swww = inputs.swww.packages.${pkgs.system}.default;
in {
  config = mkIf config.local.profiles.desktop.enable {
    systemd.user.services = {
      swww = {
        name = "swww";
        description = "Wayland wallpaper daemon";
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = "${swww}/bin/swww-daemon --format xrgb";
          ExecStartPost = updateWallpaper;
          Restart = "on-failure";
        };
      };
    };
  };
}
