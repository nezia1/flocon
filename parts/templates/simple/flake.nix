{
  description = "A simple empty flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    supportedSystems = ["x86_64-linux"];
    forAllSystems = function:
      lib.attrsets.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {};
    });
  };
}
