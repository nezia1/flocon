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
    ];
  };

  solaire = mkSystem {
    modules = [./solaire];
  };

  anastacia = mkSystem {
    modules = [./anastacia];
  };
}
