{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption pathExists;
  inherit (lib.types) bool package str;
  cfg = config.theme.gtk;
in {
  options.theme.gtk = {
    enable = mkOption {
      type = bool;
      description = "enable GTK theming options";
      default = config.theme.enable;
    };
    theme = {
      name = mkOption {
        type = str;
        description = "Name for the GTK theme";
        default = "Catppuccin-GTK-Dark";
      };
      package = mkOption {
        type = package;
        description = "Package providing the GTK theme";

        default = pkgs.magnetic-catppuccin-gtk.overrideAttrs {
          accent = "purple";
        };
      };
    };

    iconTheme = {
      name = mkOption {
        type = str;
        description = "The name for the icon theme that will be used for GTK programs";
        default = "rose-pine";
      };

      package = mkOption {
        type = package;
        description = "The GTK icon theme to be used";
        default = pkgs.rose-pine-icon-theme;
      };
    };
  };
  config = {
    assertions = [
      (let
        themePath = cfg.theme.package + /share/themes + "/${cfg.theme.name}";
      in {
        assertion = cfg.enable -> pathExists themePath;
        message = ''
          ${toString themePath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.modules.theme.gtk.theme.package` contains
          the path `${cfg.theme.name}`
        '';
      })
    ];

    home-manager.users.nezia = {
      gtk = {
        enable = true;
        iconTheme = {
          inherit (cfg.iconTheme) name package;
        };
        theme = {
          inherit (cfg.theme) name package;
        };
      };
    };
  };
}
