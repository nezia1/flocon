{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) attrs;

  json = pkgs.formats.json {};
  cfg = config.rum.programs.librewolf;

  policiesFile = json.generate "policies.json" {inherit (cfg) policies;};

  librewolf = cfg.package.override {
    extraPoliciesFiles = cfg.package.unwrapped.extraPoliciesFiles ++ [policiesFile];
  };
in {
  options.rum.programs.librewolf = {
    enable = mkEnableOption "librewolf module";
    package = mkPackageOption pkgs "librewolf" {};
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
