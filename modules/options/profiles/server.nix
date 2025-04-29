{
  lib,
  config,
  ...
}: let
  inherit (builtins) isNull;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options = {
    local.profiles.server.enable = mkEnableOption "the server profile";
  };

  config.assertions = mkIf config.local.profiles.server.enable [
    {
      assertion = isNull config.local.vars.home.desktop;
      message = "The server profile cannot be enabled if any desktop is set.";
    }

    {
      assertion = !config.local.profiles.gaming.enable;
      message = "The server profile cannot be enabled if `local.profiles.gaming.enable` is set to true.";
    }
  ];
}
