{
  inputs,
  lib',
  ...
}: let
  inherit (lib') mkSystem;
in {
  vamos = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./vamos
      ../modules
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./solaire
      ../modules
    ];
  };

  anastacia = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./anastacia
    ];
  };
}
