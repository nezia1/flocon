{
  lib,
  pkgs,
  config,
  options,
  inputs,
  ...
}: let
  inherit (lib) attrNames mkEnableOption mkOption pathExists;
  inherit (lib.types) attrs bool enum package path str;

  cfg = config.local.style;
in {
  options.local.style = {
    enable = mkEnableOption "style";
    schemeName = mkOption {
      description = ''
        Name of the tinted-theming color scheme to use.
      '';
      type = enum (attrNames inputs.basix.schemeData.base16);
      example = "catppuccin-mocha";
      default = "catppuccin-mocha";
    };

    scheme = mkOption {
      description = ''
        Computed scheme from `config.local.style.schemeName`.
      '';
      type = attrs;
      readOnly = true;
    };
    wallpaper = mkOption {
      description = ''
        Location of the wallpaper that will be used throughout the system.
      '';
      type = path;
      example = lib.literalExpression "./wallpaper.png";
      default = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/e0cf0eb237dc5baba86661a3572b20a6183c1876/wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png?raw=true";
        hash = "sha256-/HAtpGwLxjNfJvX5/4YZfM8jPNStaM3gisK8+ImRmQ4=";
      };
    };

    cursorTheme = {
      name = mkOption {
        description = ''
          Name of the cursor theme.
        '';
        default = "phinger-cursors-dark";
      };
      package = mkOption {
        type = package;
        description = ''
          Package providing the cursor theme.
        '';
        default = pkgs.phinger-cursors;
      };
      size = mkOption {
        description = ''
          Size of the cursor.
        '';
        default = 32;
      };
    };

    avatar = mkOption {
      description = ''
        Path to an avatar image (used for hyprlock).
      '';
      default = ../../assets/avatar.png; # TODO silly, change this
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
          default = "adw-gtk3";
        };
        package = mkOption {
          type = package;
          description = "Package providing the GTK theme";

          default = pkgs.adw-gtk3;
        };
      };

      iconTheme = {
        name = mkOption {
          type = str;
          description = "The name for the icon theme that will be used for GTK programs";
          default = "Kora";
        };

        package = mkOption {
          type = package;
          description = "The GTK icon theme to be used";
          default = pkgs.kora-icon-theme;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (let
        themePath = cfg.gtk.theme.package + /share/themes + "/${cfg.gtk.theme.name}";
      in {
        assertion = cfg.gtk.enable -> pathExists themePath;
        message = ''
          ${toString themePath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.modules.theme.gtk.theme.package` contains
          the path `${cfg.theme.name}`
        '';
      })
      {
        assertion = cfg.enable -> options.local.systemVars.username.isDefined;
        message = ''
          When enabling system-wide theming, a username needs to be set in `config.local.systemVars.username`.
        '';
      }
    ];

    local.style.scheme = inputs.basix.schemeData.base16.${cfg.schemeName};
  };
}
