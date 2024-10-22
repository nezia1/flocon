{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) pathExists;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) package str;

  cfg = config.theme.gtk;
in {
  options.theme.gtk = {
    enable = mkEnableOption "enable GTK theming options";
    theme = {
      name = mkOption {
        type = str;
        description = "Name for the GTK theme";
        default = "catppuccin-macchiato-lavender-standard";
      };
      package = mkOption {
        type = package;
        description = "Package providing the GTK theme";

        default = pkgs.catppuccin-gtk.override {
          # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/data/themes/catppuccin-gtk/default.nix
          variant = "macchiato";
          accents = ["lavender"];
          size = "standard";
        };
      };
    };
    iconTheme = {
      name = mkOption {
        type = str;
        description = "The name for the icon theme that will be used for GTK programs";
        default = "Papirus-Dark";
      };

      package = mkOption {
        type = package;
        description = "The GTK icon theme to be used";
        default = pkgs.catppuccin-papirus-folders.override {
          accent = "lavender";
          flavor = "macchiato";
        };
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
  };
}
