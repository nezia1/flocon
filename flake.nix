{
  description = "nezia's nixos configuration";

  outputs = {
    self,
    nixpkgs,
    agenix,
    deploy-rs,
    treefmt-nix,
    pre-commit-hooks,
    ...
  } @ inputs: let
    supportedSystems = nixpkgs.lib.singleton "x86_64-linux";
    forAllSystems = function:
      nixpkgs.lib.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});
    treefmtEval = forAllSystems (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    npins = import ./npins;
  in {
    checks = forAllSystems (pkgs:
      {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
        /*
        some treefmt formatters are not supported in pre-commit-hooks,
        we filter them out for now.
        */
        pre-commit-check = let
          toFilter = [
            "yamlfmt"
            "nixfmt"
            "ruff" # creates warning as the name is deprecated, not used anyway
          ];
          filterFn = n: _v: (!builtins.elem n toFilter);
          treefmtFormatters = pkgs.lib.mapAttrs (_n: v: {inherit (v) enable;}) (
            pkgs.lib.filterAttrs filterFn treefmtEval.${pkgs.system}.config.programs
          );
        in
          pre-commit-hooks.lib.${pkgs.system}.run {
            src = ./.;
            hooks = treefmtFormatters;
          };
      }
      // deploy-rs.lib.${pkgs.system}.deployChecks self.deploy);
    deploy.nodes = import ./nodes.nix {inherit inputs;};
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${pkgs.system}.pre-commit-check.enabledPackages;
        packages = [
          pkgs.alejandra
          pkgs.git
          deploy-rs.packages.${pkgs.system}.default
          agenix.packages.${pkgs.system}.default
          pkgs.npins
        ];
      };
    });
    formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    nixosConfigurations = import ./hosts {inherit self inputs npins;};
    hjemModules = {
      hjem = nixpkgs.lib.modules.importApply ./shared/modules/hjem/hjem.nix {inherit (nixpkgs) lib;};
      hjem-rum = nixpkgs.lib.modules.importApply ./shared/modules/hjem-rum/hjem.nix {inherit (nixpkgs) lib;};
    };
    packages = forAllSystems (pkgs: import ./shared/pkgs {inherit inputs pkgs npins;});
  };
  inputs = {
    # nix related
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    basix = {
      url = "github:notashelf/basix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";

      inputs.utils.follows = "flake-utils"; # Yes, it's actually called `utils`, not a typo
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.systems.follows = "systems";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";

        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";

        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "systems";
      };
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-utils.follows = "flake-utils";
        flake-parts.follows = "flake-parts";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww = {
      url = "github:LGFae/swww";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nezia_dev = {
      url = "github:nezia1/nezia.dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dependency pinning to prevent duplicate versions
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  nixConfig = {
    extra-substituters = [
      # use nixos cache first
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
}
