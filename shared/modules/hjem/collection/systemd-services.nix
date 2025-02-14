{
  lib,
  config,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.attrsets) nameValuePair mapAttrs';
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) attrs attrsOf submodule;
  inherit (lib.trivial) isBool boolToString;
  inherit (lib.generators) toINI;

  cfg = config.systemd;

  toSystemdUnitFiles = services: let
    toSystemdUnit = arg:
      toINI {
        listsAsDuplicateKeys = true;
        mkKeyValue = key: value: let
          value' =
            if isBool value
            then boolToString value
            else toString value;
        in "${key}=${value'}";
      }
      arg;
  in
    mapAttrs' (name: service:
      nameValuePair ".config/systemd/user/${name}.service" {text = toSystemdUnit service.settings;})
    services;
in {
  options.systemd = {
    services = mkOption {
      type = attrsOf (submodule {
        options = {
          settings = mkOption {
            type = attrs;
            default = {};
            description = ''
              The configuration of this unit. Each attribute in this set specifies an option
              (documentation for available options can be found [here](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)).
            '';
          };
        };
      });
      default = {};
      description = ''
        Definition of systemd user service units.
      '';
    };
  };

  config = mkIf (cfg.services != {}) {
    files = toSystemdUnitFiles cfg.services;
  };
}
