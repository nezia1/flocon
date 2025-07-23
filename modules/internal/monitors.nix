{
  lib,
  config,
  ...
}: let
  inherit (builtins) all length filter map concatStringsSep;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf bool float int str submodule nullOr;
  inherit (lib.trivial) pipe;

  cfg = config.local.monitors;
in {
  options.local.monitors = mkOption {
    type = listOf (
      submodule {
        options = {
          name = mkOption {
            type = str;
            example = "DP-1";
          };
          primary = mkOption {
            type = bool;
            default = false;
          };
          width = mkOption {
            type = int;
            example = 1920;
          };
          height = mkOption {
            type = int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = int;
            default = 60;
          };
          position = mkOption {
            type = nullOr (submodule {
              # x and y are set as nullable so that we may give a more explicit error in assertions!
              options = {
                x = mkOption {
                  type = nullOr int;
                  default = null;
                };
                y = mkOption {
                  type = nullOr int;
                  default = null;
                };
              };
            });
            default = null;
          };

          scale = mkOption {
            type = float;
            default = 1.0;
          };
        };
      }
    );
    default = [];
  };
  config = {
    assertions = let
      numMonitors = length cfg;
      numPrimaryMonitors = length (filter checks.isPrimary cfg);
      checks = {
        positionValid = m: m.position != null -> (m.position.x != null && m.position.y != null);
        isPrimary = m: m.primary;
      };
      affectedMonitorsNames = check:
        pipe cfg [
          (filter check)
          (map (m: m.name))
          (concatStringsSep ", ")
        ];
    in [
      {
        assertion = (numMonitors != 0) -> (numPrimaryMonitors == 1);
        message = "Exactly one monitor must be set to primary. Affected monitors: ${affectedMonitorsNames checks.isPrimary}";
      }
      {
        assertion = all checks.positionValid cfg;
        message = "If position is set, x and y need to be set. Affected monitors: ${affectedMonitorsNames checks.positionValid}";
      }
    ];
  };
}
