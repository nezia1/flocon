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

  writeEnvScript = let
    toEnv = env:
      if isList env
      then concatStringsSep ":" (map toString env)
      else toString env;
  in
    attrs:
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
        + (concatStringsSep "\n"
          (mapAttrsToList (name: value: "export ${name}=\"${toEnv value}\"") attrs))
      );
in {
  options.environment = {
    sessionVariables = mkOption {
      type = attrsOf (oneOf [(listOf (oneOf [int str path])) int str path]);
      default = {};
      example = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      description = ''
        A set of environment variables used in the user environment.
        These variables will be set using {file}`~/.profile`.

        If a list of strings is used, they will be concatenated with colon
        characters.
      '';
    };
  };

  config.files.".profile".text = mkIf (cfg.sessionVariables != {}) ''
    . ${writeEnvScript cfg.sessionVariables}
  '';
}
