{
  description = "nezia's nixos configuration";

  outputs = {
    self,
    nixpkgs,
    systems,
    treefmt-nix,
    ...
  } @ inputs: let
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.alejandra
          pkgs.git
        ];
      };
    });
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    nixosModules = import ./modules;
    nixosConfigurations = import ./hosts {inherit self inputs;};
  };
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {url = "github:notashelf/nvf";};
    basix.url = "github:notashelf/basix";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    ags.url = "github:Aylur/ags";
    niri = {url = "github:sodiboo/niri-flake";};
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };
}
