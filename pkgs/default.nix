pkgs: {
  mcuxpresso = import ./mcuxpresso pkgs;
  bolt-launcher = pkgs.callPackage ./bolt-launcher.nix {};
}
