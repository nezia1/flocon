{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  styleCfg = config.local.style;
in {
  config = with styleCfg;
    mkIf styleCfg.enable {
      hj.rum.gtk = with styleCfg; {
        enable = true;
        packages = [
          gtk.theme.package
          gtk.iconTheme.package
          pkgs.adwaita-icon-theme # add as fallback
        ];

        settings = {
          icon-theme-name = gtk.iconTheme.name;
          theme-name = gtk.theme.name;
          application-prefer-dark-theme = colors.scheme.variant == "dark";
        };

        css = rec {
          gtk3 = import ./style.nix colors.scheme.palette;
          gtk4 = gtk3;
        };
      };
    };
}
