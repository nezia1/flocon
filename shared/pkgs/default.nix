{pkgs, ...}: {
  mcuxpresso = pkgs.callPackage ./mcuxpresso.nix {};
}
