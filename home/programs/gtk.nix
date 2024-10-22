{
  inputs,
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  isDark = inputs.basix.schemeData.base16.${osConfig.theme.scheme}.variant == "dark";
in {
  home.pointerCursor = {
    inherit (osConfig.theme.cursorTheme) name package size;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = ":menu";
      gtk-application-prefer-dark-theme = isDark;
    };

    gtk4.extraConfig = {
      gtk-decoration-layout = ":menu";
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      inherit (osConfig.theme.gtk.iconTheme) name package;
    };

    theme = lib.mkIf (!osConfig.services.xserver.desktopManager.gnome.enable) {
      inherit (osConfig.theme.gtk.theme) name package;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme =
        if isDark
        then "prefer-dark"
        else "default";
    };
  };
}
