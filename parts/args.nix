{inputs, ...}: {
  perSystem = {
    config,
    system,
    ...
  }: {
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
      pinnedSources = import ./npins;
    in {
      inherit lib;
      lib' = import ../lib lib;
      pins = pinnedSources;
    };
  };
}
