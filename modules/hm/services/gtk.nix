{
  lib,
  osConfig,
  ...
}: let
  styleCfg = osConfig.local.style;
in {
  config = with styleCfg;
    lib.mkIf styleCfg.enable {
      gtk = rec {
        enable = true;
        iconTheme = {
          inherit (gtk.iconTheme) name package;
        };
        theme = {
          inherit (gtk.theme) name package;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = scheme.variant == "dark";
        };
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-${scheme.variant}";
    };
}
