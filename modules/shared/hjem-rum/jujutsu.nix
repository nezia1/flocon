{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;

  toml = pkgs.formats.toml {};

  cfg = config.rum.programs.jujutsu;
in {
  options.rum.programs.jujutsu = {
    enable = mkEnableOption "jujutsu";
    package = mkPackageOption pkgs "jujutsu" {};
    settings = mkOption {
      inherit (toml) type;
      default = {};
      description = ''
        Jujutsu configuration, mapped to TOML under {file}`$XDG_CONFIG_HOME/.config/jj/config.toml`
      '';
    };
  };

  config = mkIf cfg.enable {
    packages = [cfg.package];
    xdg.config.files = {
      "jj/config.toml".source = mkIf (cfg.settings != {}) (toml.generate "jj-config.toml" cfg.settings);
    };
  };
}
