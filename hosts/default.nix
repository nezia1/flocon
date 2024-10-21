{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    specialArgs = {
      inherit inputs self;
    };
  in {
    vamos = nixosSystem {
      inherit specialArgs;
      modules = [
        ./vamos

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

        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };

    solaire = nixosSystem {
      inherit specialArgs;
      modules = [
        ./solaire
        self.nixosModules.style
        {
          style = {
            gtk.enable = false;
            wallpaper = ../wallpapers/lucy-edgerunners-wallpaper.jpg;
          };
        }
      ];
    };
  };
}
