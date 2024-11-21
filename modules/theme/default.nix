{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf attrNames;
  inherit (lib.types) path package enum;
  cfg = config.theme;
in {
  imports = [./gtk.nix];
  options.theme = {
    enable = mkEnableOption "theme";
    schemeName = mkOption {
      description = ''
        Name of the tinted-scheming color scheme to use.
      '';
      type = enum (attrNames inputs.basix.schemeData.base16);
      example = "catppuccin-macchiato";
      default = "catppuccin-macchiato";
    };

    scheme = mkOption {
      description = ''
        Resolved scheme from the tinted-scheming library.
      '';
      type = lib.types.attrs;
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
        default = "Bibata-Modern-Classic";
      };
      package = mkOption {
        type = package;
        description = ''
          Package providing the cursor theme.
        '';
        default = pkgs.bibata-cursors;
      };
      size = mkOption {
        description = ''
          Size of the cursor.
        '';
        default = 24;
      };
    };
  };
  config.theme = mkIf cfg.enable {
    scheme = inputs.basix.schemeData.base16.${config.theme.schemeName};
  };
}
