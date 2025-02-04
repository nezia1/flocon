# heavily borrowed from https://github.com/Lunarnovaa/nixconf/blob/f88254f1938211853f6005426fe19ba4b889e854/modules/desktop/theming/gtk.nix
{
  lib,
  pkgs,
  config,
  lib',
  ...
}: let
  inherit (lib'.generators.gtk) finalGtk2Text toGtk3Ini;
  inherit (config.local.systemVars) username;

  styleCfg = config.local.style;

  gtkSettings = with styleCfg; {
    gtk-icon-theme-name = gtk.iconTheme.name;
    gtk-theme-name = gtk.theme.name;
    gtk-cursor-theme-name = cursorTheme.name;
    gtk-application-prefer-dark-theme = scheme.variant == "dark";
  };
in {
  config = with styleCfg;
    lib.mkIf styleCfg.enable {
      hjem.users.${username} = let
        gtkCss = pkgs.writeText "gtk-colors" (import ./style.nix lib' styleCfg.scheme.palette);
      in {
        files = {
          ".gtkrc-2.0".text = finalGtk2Text {attrs = gtkSettings;};
          ".config/gtk-3.0/settings.ini".text = toGtk3Ini {
            Settings = gtkSettings;
          };
          ".config/gtk-4.0/settings.ini".text = toGtk3Ini {
            Settings = gtkSettings;
          };
          ".config/gtk-3.0/gtk.css".source = gtkCss;
          ".config/gtk-4.0/gtk.css".source = gtkCss;
        };
        packages = with styleCfg; [
          gtk.theme.package
          cursorTheme.package
          gtk.iconTheme.package
        ];

        environment.sessionVariables = {
          GTK2_RC_FILES = "${config.hjem.users.${username}.directory}/.gtkrc-2.0";
          GTK_THEME = "${gtkSettings.gtk-theme-name}";
        };
      };
    };
}
