{inputs, ...}: let
  lib' = import ../lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules = args.modules or [];
    };
in {
  vamos = mkSystem {
    modules = [
      ./vamos
      ../modules
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    modules = [
      ./solaire
      ../modules
    ];
  };

  anastacia = mkSystem {
    modules = [
      ./anastacia
    ];
  };
}
