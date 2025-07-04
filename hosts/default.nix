{
  self,
  inputs,
  withSystem,
  ...
}: let
  base = [
    # TODO: replace with base when the module-based state has been removed
    ../config
    ../modules/internal
    inputs.agenix.nixosModules.default
  ];
  mkNixosSystem = {system, ...} @ args:
    withSystem system (
      {
        inputs',
        self',
        pins,
        lib,
        myLib,
        ...
      }:
        lib.nixosSystem {
          specialArgs = {inherit inputs inputs' self self' myLib pins;};
          modules = myLib.resolveAndFilter ((args.modules or []) ++ base);
        }
    );
in {
  flake.nixosConfigurations = {
    vamos = mkNixosSystem {
      system = "x86_64-linux";
      modules = [
        ./vamos
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };

    solaire = mkNixosSystem {
      system = "x86_64-linux";
      modules = [./solaire];
    };

    anastacia = mkNixosSystem {
      system = "x86_64-linux";
      modules = [./anastacia];
    };
  };
}
