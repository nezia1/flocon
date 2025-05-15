{
  lib,
  lib',
  ...
}: {
  colors = import ./colors.nix {inherit lib lib';};
  generators = import ./generators {inherit lib lib';};
}
