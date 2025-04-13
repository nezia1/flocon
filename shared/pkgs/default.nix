{
  pkgs,
  npins,
  ...
}: {
  app2unit = pkgs.callPackage ./app2unit.nix {inherit npins;};
  mcuxpresso-udev = pkgs.callPackage ./mcuxpresso-udev.nix {};
}
