{
  lib,
  pkgs,
  config,
  options,
  inputs',
  ...
}: let
  inherit (builtins) pathExists toString;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) listOf bool path str;

  cfg = config.local.style;
in {
  options.local.style = {
    enable = mkEnableOption "style";
    wallpapers = mkOption {
      description = ''
        Location of the wallpaper that will be used throughout the system.
      '';
      type = listOf path;
      example = lib.literalExpression "./wallpaper.png";
    };

    cursors = {
      size = mkOption {
        description = ''
          Size of the cursor.
        '';
        default = 32;
      };
      xcursor = {
        name = mkOption {
          description = ''
            Name of the Xcursor theme.
          '';
          default = "phinger-cursors-dark";
        };
        package = mkOption {
          default = pkgs.phinger-cursors;
          description = ''
            Package providing the Xcursor theme.
          '';
        };
      };

      hyprcursor = {
        name = mkOption {
          description = ''
            Name of the hyprcursor theme.
          '';
          default = "phinger-cursors-dark-hyprcursor";
        };
        package = mkOption {
          inherit (inputs'.hyprcursor-phinger.packages) default;
          description = ''
            Package providing the hyprcursor theme.
          '';
        };
      };
    };

    gtk = {
      enable = mkOption {
        type = bool;
        description = "enable GTK theming options";
        default = cfg.enable;
      };
      theme = {
        name = mkOption {
          type = str;
          description = "Name for the GTK theme";
          default = "adw-gtk3-dark";
        };
        package = mkPackageOption pkgs "GTK theme" {
          default = "adw-gtk3";
        };
      };

      iconTheme = {
        name = mkOption {
          type = str;
          description = "The name for the icon theme that will be used for GTK programs";
          default = "Papirus-Dark";
        };

        package = mkPackageOption pkgs "GTK icon theme" {
          default = "papirus-icon-theme";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (let
        themePath = cfg.gtk.theme.package + /share/themes + "/${cfg.gtk.theme.name}";
      in {
        assertion = cfg.gtk.enable -> pathExists themePath;
        message = ''
          ${toString themePath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.local.theme.gtk.theme.package` contains
          the path `${cfg.gtk.theme.name}`
        '';
      })
      (let
        iconPath = cfg.gtk.iconTheme.package + /share/icons + "/${cfg.gtk.iconTheme.name}";
      in {
        assertion = cfg.gtk.enable -> pathExists iconPath;
        message = ''
          ${toString iconPath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.local.theme.gtk.iconTheme.package` contains
          the path `${cfg.gtk.iconTheme.name}`
        '';
      })
      {
        assertion = cfg.enable -> options.local.vars.system.username.isDefined;
        message = ''
          When enabling system-wide theming, a username needs to be set in
          `config.local.vars.systemVars.username`.
        '';
      }
    ];
  };
}
