{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.modules.hyprland.enable {
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
