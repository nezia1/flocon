{
  self,
  inputs,
  npins,
  ...
}: let
  lib' = import ../lib inputs.nixpkgs.lib;

  getPkgs = input: system:
    if (input.legacyPackages.${system} or {}) == {}
    then input.packages.${system}
    else input.legacyPackages.${system};

  mkSystem = args @ {system, ...}:
    inputs.nixpkgs.lib.nixosSystem {
      system = null;
      specialArgs = {inherit inputs;};
      modules =
        [
          {
            _module.args = {
              inherit self lib' npins;
              flakePkgs = builtins.mapAttrs (_: value: getPkgs value system) inputs;
            };
          }
        ]
        ++ (args.modules or [])
        ++ [../modules];
    };
in {
  vamos = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./vamos
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];
  };

  solaire = mkSystem {
    system = "x86_64-linux";
    modules = [./solaire];
  };

  anastacia = mkSystem {
    system = "x86_64-linux";
    modules = [./anastacia];
  };
}
