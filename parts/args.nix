{inputs, ...}: {
  perSystem = {system, ...}: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
      overlays = [inputs.self.overlays.default];
    };

    _module.args = let
      inherit (inputs.nixpkgs) lib;
      lib' = import ../lib {inherit lib lib';};
      pinnedSources = import ./npins;
    in {
      inherit lib lib';
      pins = pinnedSources;
    };
  };
}
