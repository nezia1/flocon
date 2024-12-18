# stolen from https://raw.githubusercontent.com/carlsvelz/dotfiles/a7a109b2e19f73062b4961e7be75836e6d13408c/home/wayland/swaybg.nix
{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${osConfig.local.style.wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
