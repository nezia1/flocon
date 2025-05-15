{
  lib,
  lib',
  ...
}: {
  toHyprConf = import ./tohyprconf.nix {inherit lib lib';};
  gtk = import ./gtk.nix {inherit lib lib';};
}
