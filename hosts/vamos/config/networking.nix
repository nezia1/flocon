{config, ...}: {
  age.secrets = {
    eduroam.file = ../../../secrets/eduroam.age;
  };

  # Sets regulatory domain to Europe.
  # https://wiki.archlinux.org/title/Framework_Laptop_13#Wi-Fi_performance_on_AMD_edition
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="FR"
  '';

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.age.secrets.eduroam.path
    ];

    profiles = {
      eduroam = {
        connection = {
          id = "eduroam";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          anonymous-identity = "eduroam@hes-so.ch";
          eap = "peap";
          phase2-auth = "mschapv2";
          ca-cert = "${./hesso_ca.pem}";
          identity = "$EDUROAM_IDENTITY";
          password = "$EDUROAM_PASSWORD";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };
}
