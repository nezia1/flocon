{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;

    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = ":menu";
    };

    gtk4.extraConfig = {
      gtk-decoration-layout = ":menu";
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}
