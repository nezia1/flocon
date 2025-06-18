{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) attrs;

  cfg = config.rum.programs.librewolf;

  librewolf = pkgs.wrapFirefox cfg.package {
    extraPolicies = cfg.policies;
  };
in {
  options.rum.programs.librewolf = {
    enable = mkEnableOption "librewolf module";
    package = mkPackageOption pkgs "librewolf-unwrapped" {};
    policies = mkOption {
      type = attrs;
      default = {};
      example = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
      };
      description = ''
        An attribute set of policies to add to Librewolf. The full list of policies can be found
        [here](https://mozilla.github.io/policy-templates/).
      '';
    };
  };
  config = mkIf cfg.enable {
    packages = [librewolf];
  };
}
