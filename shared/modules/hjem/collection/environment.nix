{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) isList;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) attrsOf listOf oneOf int path str;
  inherit (pkgs) writeShellScript;

  cfg = config.environment;

  toEnv = env:
    if isList env
    then concatStringsSep ":" (map toString env)
    else toString env;

  mkEnvVars = vars: (concatStringsSep "\n"
    (mapAttrsToList (name: value: "export ${name}=\"${toEnv value}\"") vars));

  writeEnvScript = attrs:
    writeShellScript "set-environment"
    (mkEnvVars attrs);
in {
  options.environment = {
    setEnvironment = mkOption {
      type = path;
      readOnly = true;
      description = ''
        A POSIX compliant shell script containing the user session variables needed to bootstrap the session.

        As there is no reliable and agnostic way of setting session variables, Hjem's
        environment module does nothing by itself. Rather, it provides a POSIX compliant shell script
        that needs to be sourced where needed.
      '';
    };
    sessionVariables = mkOption {
      type = attrsOf (oneOf [(listOf (oneOf [int str path])) int str path]);
      default = {};
      example = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      description = ''
        A set of environment variables used in the user environment.
        If a list of strings is used, they will be concatenated with colon
        characters.
      '';
    };
  };

  config = mkIf (cfg.sessionVariables != {}) {
    environment.setEnvironment = writeEnvScript cfg.sessionVariables;
  };
}
