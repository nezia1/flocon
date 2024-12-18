{config, ...}: {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
        "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
        "inode/directory" = ["yazi.desktop"];
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "image/png" = ["org.gnome.Loupe.desktop"];
        "image/svg" = [" org.gnome.Loupe.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "image/gif" = [" org.gnome.Loupe.desktop"];
        "video/mp4" = ["io.github.celluloid_player.Celluloid.desktop"];
        "video/avi" = ["io.github.celluloid_player.Celluloid.desktop"];
        "video/mkv" = ["io.github.celluloid_player.Celluloid.desktop"];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
