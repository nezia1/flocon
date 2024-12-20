{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
  inherit (cfg) scheme;
in {
  home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      gtk = rec {
        enable = true;
        iconTheme = {
          inherit (cfg.gtk.iconTheme) name package;
        };
        theme = {
          inherit (cfg.gtk.theme) name package;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = scheme.variant == "dark";
        };
        gtk4.extraConfig = gtk3.extraConfig;
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-${scheme.variant}";
    }
  ];
}
