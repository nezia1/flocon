{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) str;
in {
  options.local.homeVars = {
    fullName = mkOption {
      type = str;
      description = "your full name (used for git commits and user description)";
      default = null;
    };
    email = mkOption {
      type = str;
      description = "your email (used for git commits)";
      default = null;
    };
  };

  config.assertions = mkIf (!config.local.profiles.server.enable) [
    {
      assertion = options.local.homeVars.fullName.isDefined;
    }
    {
      assertion = options.local.homeVars.email.isDefined;
    }
  ];
}
