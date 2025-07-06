{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options.local.vars.home = {
    fullName = mkOption {
      type = str;
      default = "User";
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
  };
}
