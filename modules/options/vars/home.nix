{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) enum nullOr str;
in {
  options.local.vars.home = {
    fullName = mkOption {
      type = str;
      description = "your full name (used for git commits and user description)";
      default = "User";
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

    desktop = mkOption {
      type = nullOr (enum ["Hyprland"]);
      default = null;
      description = ''
        The desktop environment to be used.
      '';
    };
  };

  config.assertions = mkIf (!config.local.profiles.server.enable) [
    {
      assertion = options.local.vars.home.fullName.isDefined;
    }
    {
      assertion = options.local.vars.home.email.isDefined;
    }
    {
      assertion = options.local.vars.home.signingKey.isDefined;
    }
  ];
}
