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
    signingKey = mkOption {
      type = str;
      description = "your ssh public key (used for signing git commits)";
    };

    userEnvFile = mkOption {
      type = str;
      description = "filename where the user environment variables such as EDITOR will be stored, under `$XDG_CONFIG_HOME/environment.d` (needs to be a file name without extension).";
      default = "99-user-env";
      example = "99-user-env";
    };
  };

  config.assertions = mkIf (!config.local.profiles.server.enable) [
    {
      assertion = options.local.homeVars.fullName.isDefined;
    }
    {
      assertion = options.local.homeVars.email.isDefined;
    }
    {
      assertion = options.local.homeVars.signingKey.isDefined;
    }
    {
      assertion = options.local.homeVars.userEnvFile.isDefined;
    }
  ];
}
