{
  lib,
  config,
  ...
}: let
  inherit (builtins) length filter;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf bool float int str submodule;
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
            type = str;
            default = "auto";
          };
          scale = mkOption {
            type = float;
            default = 1;
          };
        };
      }
    );
    default = [];
  };
  config = {
    assertions = [
      {
        assertion =
          ((length config.local.monitors) != 0)
          -> ((length (filter (m: m.primary) config.local.monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
  };
}
