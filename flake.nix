{
  description = "nezia's nixos configuration";

  outputs = {
    self,
    nixpkgs,
    systems,
    agenix,
    deploy-rs,
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
          deploy-rs.packages.${pkgs.system}.default
          agenix.packages.${pkgs.system}.default
        ];
      };
    });
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    nixosModules = import ./modules;
    nixosConfigurations = let
      lib' = import ./lib {inherit inputs lib';};
    in
      import ./hosts {inherit inputs lib';};
    packages = eachSystem (pkgs: import ./pkgs {inherit inputs pkgs;});
    deploy.nodes = import ./nodes {inherit self inputs;};
  };
  inputs = {
    # nix related
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    basix.url = "github:notashelf/basix";
    deploy-rs.url = "github:serokell/deploy-rs";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    nvf.url = "github:notashelf/nvf";

    portfolio.url = "github:nezia1/portfolio";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
