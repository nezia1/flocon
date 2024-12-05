{pkgs, ...}: {
  theme = {
    enable = true;
    wallpaper = ../../../wallpapers/lucy-edgerunners-wallpaper.jpg;
    schemeName = "rose-pine";
    gtk.theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
  };
}
