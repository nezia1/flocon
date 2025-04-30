{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options = {
    local.profiles.server.enable = mkEnableOption "the server profile";
  };

  config.assertions = mkIf config.local.profiles.server.enable [
    {
      assertion = config.local.vars.home.desktop == null;
      message = "The server profile cannot be enabled if any desktop is set.";
    }

    {
      assertion = !config.local.profiles.gaming.enable;
      message = "The server profile cannot be enabled if `local.profiles.gaming.enable` is set to true.";
    }
  ];
}
