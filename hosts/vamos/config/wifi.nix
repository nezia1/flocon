_: {
  # Sets regulatory domain to Europe.
  # https://wiki.archlinux.org/title/Framework_Laptop_13#Wi-Fi_performance_on_AMD_edition
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="FR"
  '';
}
