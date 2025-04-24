{
  pkgs,
  npins,
  ...
}: {
  app2unit = pkgs.callPackage ./app2unit.nix {inherit npins;};
  mcuxpresso-udev = pkgs.callPackage ./mcuxpresso-udev.nix {};
  universal-gnome-control-center = pkgs.callPackage ./universal-gnome-control-center.nix {};
}
