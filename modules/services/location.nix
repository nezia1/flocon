{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    location.provider = "geoclue2";

    services.geoclue2 = {
      enable = true;
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
      submissionUrl = "https://beacondb.net/v2/geosubmit";
      submissionNick = "geoclue";

      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
