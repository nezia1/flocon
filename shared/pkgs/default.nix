{pkgs, ...}: {
  mcuxpresso-udev = pkgs.callPackage ./mcuxpresso-udev.nix {};
}
