{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) enum nullOr str;

  cfg = config.local.vars.home;
  opts = options.local.vars.home;
in {
  options.local.vars.home = {
    fullName = mkOption {
      type = str;
      description = "your full name (used for git commits and user description)";
    };
    email = mkOption {
      type = str;
      description = "your email (used for git commits)";
    };
    signingKey = mkOption {
      type = str;
      description = "your ssh public key (used for signing git commits)";
    };

    desktop = {
      name = mkOption {
        type = nullOr (enum ["Hyprland"]);
        default = null;
        description = ''
          The desktop environment to be used.
        '';
      };
      type = mkOption {
        type = nullOr (enum ["wm" "de"]);
        default = null;
        description = ''
          The desktop "type" (used for toggling programs and services for more minimal environments).
        '';
      };
    };
  };

  config.assertions = mkIf (!config.local.profiles.server.enable) [
    {
      assertion = opts.fullName.isDefined;
    }
    {
      assertion = opts.email.isDefined;
    }
    {
      assertion = opts.signingKey.isDefined;
    }
    {
      assertion = cfg.desktop.name != null -> cfg.desktop.type != null;
      message = "${opts.desktop.type} must be specified when ${opts.desktop.name} is set";
    }
  ];
}
