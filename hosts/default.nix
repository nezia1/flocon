{inputs, ...}: let
  lib' = import ../lib inputs.nixpkgs.lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules =
        (args.modules or [])
        ++ [
          ../modules
          inputs.hjem.nixosModules.default
        ];
    };
in {
  vamos = mkSystem {
    modules = [
      ./vamos
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    modules = [./solaire];
  };

  anastacia = mkSystem {
    modules = [./anastacia];
  };
}
