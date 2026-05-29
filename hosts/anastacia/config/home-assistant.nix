{config, ...}: {
  # https://github.com/nickolaj-jepsen/nixos/blob/06a30364e4cb520b468269fe5499e99cb7b797f0/modules/homelab/home-assistant/hass.nix#L12-L18
  age.secrets.hassSecrets = {
    file = ../../../secrets/hass.yaml.age;
    path = "${config.services.home-assistant.configDir}/secrets.yaml";
    mode = "400";
    owner = "hass";
    group = "hass";
  };

  services.esphome = {
    enable = true;
    address = "0.0.0.0";
    openFirewall = true;
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "esphome"
      "somfy"
      "mobile_app"
    ];
    config = {
      homeassistant = {
        name = "Home";
        time_zone = config.time.timeZone;
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        temperature_unit = "C";
      };
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
    };
  };
}
