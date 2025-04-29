{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.attrsets) attrNames;
  inherit (lib.options) mkOption;
  inherit (lib.types) attrs enum;
  inherit (lib.modules) mkIf;

  allSchemes = (attrNames inputs.basix.schemeData.base16) ++ (attrNames inputs.basix.schemeData.base24);

  cfg = config.local.style;
in {
  options.local.style.colors = {
    schemeName = mkOption {
      type = enum allSchemes;
      description = ''
        Name of the tinted-theming color scheme to use.
      '';
      default = "catppuccin-mocha";
      example = "";
    };
    system = mkOption {
      type = enum ["base16" "base24"];
      default = "base24";
      description = ''
        The color system to use.
      '';
    };
    scheme = mkOption {
      type = attrs;
      description = ''
        Computed scheme from `config.local.style.colors.schemeName`.
      '';
      readOnly = true;
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = elem cfg.colors.schemeName (attrNames inputs.basix.schemeData.${cfg.colors.system});
        message = ''
          The color scheme ${cfg.colors.schemeName} is not available in ${cfg.colors.system}.
        '';
      }
    ];

    local.style.colors.scheme = inputs.basix.schemeData.${cfg.colors.system}.${cfg.colors.schemeName};
  };
}
