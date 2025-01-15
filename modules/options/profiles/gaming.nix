{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options = {
    local.profiles.gaming.enable = mkEnableOption "the gaming profile";
  };

  config.assertions = lib.mkIf config.local.profiles.gaming.enable [
    {
      assertion = !config.local.profiles.server.enable;
      message = "The gaming profile cannot be enabled if `local.profiles.server.enable` is set to true.";
    }
  ];
}
