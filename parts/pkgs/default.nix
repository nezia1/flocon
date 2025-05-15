_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages = lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./packages;
    };
  };
}
