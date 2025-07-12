{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) submodule str nullOr;

  themeType = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "The kvantum theme name (name of the directory containing theme files).";
      };
      package = mkPackageOption pkgs "kvantum theme" {
        default = null;
      };
    };
  };
  themePath = theme: "${theme.package}/share/Kvantum/${theme.name}";

  ini = pkgs.formats.ini {};

  cfg = config.local.misc.kvantum;
in {
  options.local.misc.kvantum = {
    enable = mkEnableOption "kvantum";
    theme = mkOption {
      type = nullOr themeType;
      default = null;
    };
    extraSettings = mkOption {
      type = nullOr ini.type;
      default = null;
      description = ''
        Extra kvantum configuration, to be added under {file}`$HOME/.config/Kvantum.kvantum.kvconfig`.
      '';
    };
  };

  config = mkIf cfg.enable {
    files = {
      ".config/Kvantum/kvantum.kvconfig".source = mkIf (cfg.theme != null) (
        ini.generate "kvantum-config" ({
            General.theme = cfg.theme.name;
          }
          // optionalAttrs (cfg.extraSettings != null) cfg.extraSettings)
      );
      ".config/Kvantum/${cfg.theme.name}".source = mkIf (cfg.theme != null) (themePath cfg.theme);
    };
  };
}
