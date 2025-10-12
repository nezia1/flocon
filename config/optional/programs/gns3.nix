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
  environment.systemPackages = [
    gns3-gui
    pkgs.inetutils
    pkgs.wireshark
  ];
}
