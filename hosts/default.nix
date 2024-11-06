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

      inputs.self.nixosModules.theme

      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./solaire
      inputs.self.nixosModules.theme
    ];
  };

  anastacia = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./anastacia
    ];
  };
}
