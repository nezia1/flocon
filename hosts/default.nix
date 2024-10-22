{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  specialArgs = {
    inherit inputs self;
  };
in {
  vamos = nixosSystem {
    system = "x86_64-linux";
    inherit specialArgs;
    modules = [
      ./vamos

      self.nixosModules.theme

      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = nixosSystem {
    system = "x86_64-linux";
    inherit specialArgs;
    modules = [
      ./solaire
      self.nixosModules.theme
    ];
  };
}
