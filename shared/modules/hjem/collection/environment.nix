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

  toEnv = env:
    if isList env
    then concatStringsSep ":" (map toString env)
    else toString env;

  mkEnvVars = vars: (concatStringsSep "\n"
    (mapAttrsToList (name: value: "export ${name}=\"${toEnv value}\"") vars));

  writeEnvScript = attrs:
    writeShellScript "load-env"
    (
      ''
        # Only execute this file once per shell.
        if [ -n "$__ETC_PROFILE_SOURCED" ]; then return; fi
        __ETC_PROFILE_SOURCED=1
        # Prevent this file from being sourced by interactive non-login child shells.
        export __ETC_PROFILE_DONE=1
        # Session variables
      ''
      + mkEnvVars attrs
    );
in {
  options.environment.sessionVariables = mkOption {
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

  config = mkIf (config.environment.sessionVariables != {}) {
    files = {
      ".profile".text = ''
        . ${writeEnvScript config.environment.sessionVariables}
      '';
      ".config/uwsm/env".text = mkEnvVars config.environment.sessionVariables;
    };
  };
}
