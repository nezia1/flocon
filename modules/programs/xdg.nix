{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      files = {
        ".config/mimeapps.list".text = ''
          [Default Applications]
          application/pdf=org.pwmt.zathura-pdf-mupdf.desktop
          default-web-browser=firefox.desktop
          image/gif= org.gnome.gThumb.desktop
          image/jpeg=org.gnome.gThumb.desktop
          image/png=org.gnome.gThumb.desktop
          image/svg= org.gnome.gThumb.desktop
          inode/directory=pcmanfm.desktop
          text/html=firefox.desktop
          video/avi=io.github.celluloid_player.Celluloid.desktop
          video/mkv=io.github.celluloid_player.Celluloid.desktop
          video/mp4=io.github.celluloid_player.Celluloid.desktop
          x-scheme-handler/about=firefox.desktop
          x-scheme-handler/chrome=chromium-browser.desktop
          x-scheme-handler/http=firefox.desktop
          x-scheme-handler/https=firefox.desktop
          x-scheme-handler/unknown=firefox.desktop
        '';
      };
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
