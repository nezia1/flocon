{
  self,
  inputs,
  withSystem,
  ...
}: let
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
          modules =
            (args.modules or [])
            ++ [../modules];
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
