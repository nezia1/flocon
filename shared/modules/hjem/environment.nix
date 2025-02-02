{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrsToList;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) attrsOf listOf oneOf int path str;

  envFile = "99-user-env.conf";
  cfg = config.environment;

  toString = env:
    if builtins.isList env
    then concatStringsSep ":" env
    else builtins.toString env;

  toConf = attrs:
    concatStringsSep "\n"
    (mapAttrsToList (name: value: "${name}=\"${toString value}\"") attrs);
in {
  options.environment = {
    enable = mkEnableOption "environment management";
    variables = mkOption {
      default = {};
      example = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      description = ''
        A set of environment variables used in the user environment.
        These variables will be set as systemd environment
        variables, using `environment.d`. The value of each
        variable can be either a string or a list of strings. The
        latter is concatenated, interspersed with colon
        characters.
      '';
      type = attrsOf (oneOf [(listOf (oneOf [int str path])) int str path]);
    };
  };

  config =
    mkIf cfg.enable
    {
      files.".config/environment.d/${envFile}".text = toConf cfg.variables;

      warnings = let
        overlappingVars = builtins.filter (x: builtins.elem x (builtins.attrNames config.environment.variables)) (builtins.attrNames cfg.variables);
      in
        if overlappingVars != []
        then
          map (name: ''
            The environment variable '${name}' is defined in both
            `hjem.users.<name>.environment.variables` and
            `config.environment.variables`. This may lead to conflicts.

            If you want the one defined in hjem to take precedence, make sure you
            unset it manually in `environment.extraInit` (`unset ${name}`).
          '')
          overlappingVars
        else [];
    };
}
