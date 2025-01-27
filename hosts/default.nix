{inputs, ...}: let
  lib' = import ../shared/lib inputs.nixpkgs.lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules = (args.modules or []) ++ [../modules];
    };
in {
  vamos = mkSystem {
    modules = [
      ./vamos
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      inputs.hjem.nixosModules.default
    ];
  };

  solaire = mkSystem {
    modules = [
      ./solaire
      inputs.hjem.nixosModules.default
    ];
  };

  anastacia = mkSystem {
    modules = [./anastacia];
  };
}
