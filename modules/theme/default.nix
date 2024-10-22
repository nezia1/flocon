{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) string path package;
in {
  imports = [./gtk.nix];
  options.theme = {
    scheme = mkOption {
      description = ''
        Name of the tinted-scheming color scheme to use.
      '';
      type = string;
      example = lib.literalExpression "catppuccin-macchiato";
      default = "catppuccin-macchiato";
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
}
