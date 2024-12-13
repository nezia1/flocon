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
    nixosConfigurations = import ./hosts {inherit inputs;};
    packages = eachSystem (pkgs: import ./pkgs {inherit inputs pkgs;});
    deploy.nodes = import ./nodes {inherit inputs;};
    checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
  inputs = {
    # nix related
    nixpkgs.url = "nixpkgs/nixos-unstable";
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
    basix.url = "github:notashelf/basix";
    deploy-rs.url = "github:serokell/deploy-rs";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.5.0";
    nvf.url = "github:notashelf/nvf";
    portfolio.url = "github:nezia1/portfolio";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  nixConfig = {
    extra-substituters = [
      # use nixos cache first
      "https://cache.nixos.org?priority=10"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
