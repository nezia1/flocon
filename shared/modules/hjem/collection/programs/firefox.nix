{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrs lines package str;

  toINI = lib.generators.toINI {};

  cfg = config.programs.firefox;
  firefox = pkgs.wrapFirefox cfg.package {
    extraPolicies = cfg.policies;
  };
in {
  options.programs.firefox = {
    enable = mkEnableOption "firefox module.";
    package = mkOption {
      type = package;
      default = pkgs.firefox-esr-unwrapped;
      example = pkgs.firefox-unwrapped;
      description = ''
        The Firefox package to use. As hjem's module implementation of Firefox uses wrapping, this package
        is expected to be one of the unwrapped versions. Changing this is not recommended, as some policies
        (i.e. SearchEngines) are only available on the ESR version of Firefox.
      '';
    };
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
        An attribute set of policies to add to Firefox. The full list of policies can be found
        [here](https://mozilla.github.io/policy-templates/).
      '';
    };
    extraConfig = mkOption {
      type = lines;
      default = "";
      description = ''
        Extra preferences to add to user.js.
      '';
    };

    username = mkOption {
      type = str;
      example = "user";
      description = ''
        Name of the Firefox profile to be created.
      '';
    };
  };
  config = mkIf cfg.enable {
    packages = [firefox];
    files = {
      ".mozilla/firefox/profiles.ini".text = toINI {
        Profile0 = {
          Name = "${cfg.username}";
          IsRelative = 1;
          Path = "${cfg.username}";
          Default = 1;
        };
      };
      ".mozilla/firefox/${cfg.username}/user.js".text = cfg.extraConfig;
    };
  };
}
