{inputs, ...}: {
  perSystem = {
    config,
    system,
    pkgs,
    lib,
    ...
  }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
      overlays = [
        inputs.deploy-rs.overlays.default
      ];
    };

    _module.args = let
      myLib = lib.filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage newScope;
        directory = ../lib;
      };
      pinnedSources = import ./npins;
    in {
      inherit lib myLib;
      pins = pinnedSources;
      pkgs = config.legacyPackages;
    };
  };
}
