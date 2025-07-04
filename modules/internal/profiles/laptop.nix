{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options = {
    local.profiles.laptop.enable = mkEnableOption "the laptop profile";
  };

  config.assertions = mkIf config.local.profiles.laptop.enable [
    {
      assertion = !config.local.profiles.server.enable;
      message = "The laptop profile cannot be enabled if `local.profiles.server.enable` is set to true.";
    }
  ];
}
