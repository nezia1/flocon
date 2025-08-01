{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;

  inherit (config.local.style) gtk;

  styleCfg = config.local.style;
in {
  config = mkIf styleCfg.enable {
    hj.rum.misc.gtk = {
      enable = true;
      packages = [
        gtk.theme.package
        gtk.iconTheme.package
        pkgs.adwaita-icon-theme # add as fallback
      ];

      settings = {
        icon-theme-name = gtk.iconTheme.name;
        theme-name = gtk.theme.name;
        application-prefer-dark-theme = styleCfg.colors.scheme.variant == "dark";
      };
    };

    programs.dconf = mkIf gtk.enable {
      enable = true;
      profiles.user.databases = singleton {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = gtk.theme.name;
            icon-theme = gtk.iconTheme.name;
            color-scheme = "prefer-${styleCfg.colors.scheme.variant}";
          };
        };
      };
    };
  };
}
