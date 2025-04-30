{inputs, ...}: let
  pinnedSources = import ./npins;
in {
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

    _module.args = {
      pins = pinnedSources;
    };
  };

  flake = {
    pins = pinnedSources;
  };
}
