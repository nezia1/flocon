{
  lib,
  pkgs,
  config,
  self,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (config.local.vars.system) username;
in {
  config = mkMerge [
    (mkIf (!config.local.profiles.server.enable) {
      # TODO: switch to hjem when implemented
      hm.xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "${config.hj.directory}/Desktop";
          documents = "${config.hj.directory}/Documents";
          music = "${config.hj.directory}/Music";
          pictures = "${config.hj.directory}/Pictures";
          videos = "${config.hj.directory}/Videos";
        };
      };
      hj.environment.sessionVariables = {
        XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/Screenshots";
      };
    })
    (mkIf (config.local.vars.home.desktop.type == "wm") {
      hjem.extraModules = [self.hjemModules.xdg-autostart];
      hj = {
        files = {
          ".config/mimeapps.list".text = mkIf (config.local.vars.home.desktop.type == "wm") ''
            [Default Applications]
            application/pdf=org.gnome.Papers.desktop
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
    })
  ];
}
