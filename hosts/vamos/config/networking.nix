{pkgs, ...}: let
  gns3-gui = pkgs.gns3Packages.guiStable.overrideAttrs (final: _: {
    version = "2.2.54";
    src = pkgs.fetchFromGitHub {
      owner = "GNS3";
      repo = "gns3-gui";
      hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
      rev = "refs/tags/v${final.version}";
    };
  });
in {
  # Sets regulatory domain to Europe.
  # https://wiki.archlinux.org/title/Framework_Laptop_13#Wi-Fi_performance_on_AMD_edition
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="FR"
  '';

  # School related
  services.tailscale.enable = true;
  environment.systemPackages = [
    gns3-gui
    pkgs.inetutils
    pkgs.wireshark
  ];
}
