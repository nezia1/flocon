{
  lib,
  options,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) bool str;
in {
  options.local.systemVars = {
    hostName = mkOption {
      type = str;
      description = "hostname for the current host";
      default = null;
    };
    username = mkOption {
      type = str;
      description = "username for the home directory";
      default = null;
    };
    isServer = mkOption {
      type = bool;
      description = "whether or not this host is a server";
      default = false;
    };
  };

  config.assertions = [
    {
      assertion = options.local.systemVars.hostName.isDefined;
    }
    {
      assertion = options.local.systemVars.username.isDefined;
    }
  ];
}
