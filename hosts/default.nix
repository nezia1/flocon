{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    homeImports = import "${self}/home/profiles";
    mod = "${self}/system";
    inherit (import mod) laptop desktop;
    specialArgs = {
      inherit inputs self;
    };
  in {
    vamos = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./vamos
          "${mod}/core/lanzaboote.nix"

          "${mod}/services/greetd.nix"
          "${mod}/programs/niri"
          "${mod}/services/gnome.nix"
          self.nixosModules.style

          ({pkgs, ...}: {
            style = let
              wallpaper = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/e0cf0eb237dc5baba86661a3572b20a6183c1876/wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png?raw=true";
                hash = "sha256-/HAtpGwLxjNfJvX5/4YZfM8jPNStaM3gisK8+ImRmQ4=";
              };
            in {
              gtk.enable = true;
              inherit wallpaper;
            };
          })
          {
            home-manager = {
              users.nezia.imports = homeImports.vamos;
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.chaotic.nixosModules.default
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ];
    };

    solaire = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./solaire

          "${mod}/programs/gnome.nix"

          "${mod}/hardware/nvidia.nix"
          "${mod}/programs/games.nix"

          self.nixosModules.style
          {
            style = {
              gtk.enable = false;
              wallpaper = ../wallpapers/lucy-edgerunners-wallpaper.jpg;
            };
          }
          {
            home-manager = {
              users.nezia.imports = homeImports.solaire;
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
