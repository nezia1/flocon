{inputs, ...}: let
  lib' = import ../shared/lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules = [../shared/nixosModules] ++ (args.modules or []);
    };
in {
  vamos = mkSystem {
    modules = [
      ./vamos
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    modules = [
      ./solaire
    ];
  };

  anastacia = mkSystem {
    modules = [
      ./anastacia
    ];
  };
}
