{
  self,
  inputs,
  withSystem,
  ...
}: let
  mkNixosSystem = {system, ...} @ args:
    withSystem system (
      {
        inputs',
        self',
        pins,
        lib,
        myLib,
        ...
      }:
        lib.nixosSystem {
          specialArgs = {inherit inputs inputs' self self' myLib pins;};
          modules = myLib.resolveAndFilter (args.modules or []);
        }
    );

  base = [
    ../config/base
    ../modules/internal
    inputs.agenix.nixosModules.default
  ];

  workstation = [
    ../config/optional/core/boot.nix
    ../config/optional/core/fonts.nix
    ../config/optional/core/networking.nix
    ../config/optional/core/security.nix

    ../config/optional/hardware/bluetooth.nix
    ../config/optional/hardware/mcuxpresso.nix
    ../config/optional/hardware/printing.nix
    ../config/optional/hardware/graphics.nix

    ../config/optional/programs/editors
    ../config/optional/programs/terminal
    ../config/optional/programs/comma.nix
    ../config/optional/programs/discord.nix
    ../config/optional/programs/librewolf.nix
    ../config/optional/programs/media.nix
    ../config/optional/programs/misc.nix
    ../config/optional/programs/pcmanfm.nix
    ../config/optional/programs/xdg.nix

    ../config/optional/services/documentation.nix
    ../config/optional/services/docker.nix
    ../config/optional/services/flatpak.nix
    ../config/optional/services/keyd.nix
    ../config/optional/services/kmscon.nix
    ../config/optional/services/kwallet.nix
    ../config/optional/services/location.nix
    ../config/optional/services/pipewire.nix
    ../config/optional/services/ssh.nix

    ../config/optional/theming
  ];

  hyprland = [
    ../config/optional/services/brightness.nix

    ../config/optional/programs/hypr
    ../config/optional/programs/walker
    ../config/optional/programs/swaybg.nix
    ../config/optional/programs/waybar.nix
    ../config/optional/programs/wlogout.nix

    ../config/optional/services/gammastep.nix
    ../config/optional/services/gnome.nix
    ../config/optional/services/greetd.nix
    ../config/optional/services/logind.nix
    ../config/optional/services/power.nix
    ../config/optional/services/swaync.nix
  ];
in {
  flake.nixosConfigurations = {
    vamos = mkNixosSystem {
      system = "x86_64-linux";
      modules =
        base
        ++ workstation
        ++ hyprland
        ++ [
          ./vamos
          ../config/optional/programs/games.nix
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ];
    };

    solaire = mkNixosSystem {
      system = "x86_64-linux";
      modules =
        base
        ++ workstation
        ++ hyprland
        ++ [
          ./solaire
          ../config/optional/programs/games.nix
          ../config/optional/hardware/gamecube.nix
        ];
    };

    anastacia = mkNixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules/internal # since we do not want to be using base for the server, but we still want the local options
        ./anastacia
      ];
    };
  };
}
