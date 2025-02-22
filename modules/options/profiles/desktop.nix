{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options = {
    local.profiles.desktop.enable = mkEnableOption "the desktop profile";
  };

  config.assertions = mkIf config.local.profiles.desktop.enable [
    {
      assertion = !config.local.profiles.server.enable;
      message = "The desktop profile cannot be enabled if `local.profiles.server.enable` is set to true.";
    }
  ];
}
