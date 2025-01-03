{
  self,
  inputs,
  ...
}: let
  lib' = import ../shared/lib inputs.nixpkgs.lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules = [../shared/nixosModules] ++ (args.modules or []);
    };

  base = [
    "${self}/config/nixos"
    "${self}/config/nixos/core/home-manager.nix"

    "${self}/config/nixos/services/documentation.nix"

    "${self}/config/nixos/services/location.nix"

    ({
      config,
      specialArgs,
      ...
    }: {
      home-manager = {
        users.${config.local.systemVars.username}.imports = [
          "${self}/config/home-manager"

          "${self}/config/home-manager/services/udiskie.nix"
          "${self}/config/home-manager/services/syncthing.nix"
        ];

        extraSpecialArgs = specialArgs;
      };
    })
  ];

  graphical = [
    "${self}/config/nixos/services/logind.nix"
    "${self}/config/nixos/services/greetd.nix"

    "${self}/config/nixos/programs/hyprland.nix"
    "${self}/config/nixos/services/gnome.nix"
    ({config, ...}: {
      home-manager.users.${config.local.systemVars.username}.imports = [
        "${self}/config/home-manager/programs/waybar"
        "${self}/config/home-manager/programs/fuzzel.nix"
        "${self}/config/home-manager/programs/hypr"
        "${self}/config/home-manager/programs/wlogout.nix"

        "${self}/config/home-manager/services/swaync"

        "${self}/config/home-manager/terminal/emulators/foot.nix"
        "${self}/config/home-manager/services/gammastep.nix"
      ];
    })
  ];

  gaming = [
    ../config/nixos/programs/games.nix
    ({config, ...}: {
      home-manager.users.${config.local.systemVars.username}.imports = [
        "${self}/config/home-manager/programs/games"
        "${self}/config/home-manager/services/flatpak.nix"
      ];
    })
  ];

  laptop = [
    "${self}/config/nixos/core/lanzaboote.nix"

    "${self}/config/nixos/hardware/fprintd.nix"
    "${self}/config/nixos/services/kanata.nix"
    "${self}/config/nixos/services/power.nix"
    "${self}/config/nixos/services/brightness.nix"

    "${self}/config/nixos/hardware/mcuxpresso.nix"
  ];
in {
  vamos = mkSystem {
    modules =
      [
        ./vamos
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ]
      ++ base
      ++ graphical
      ++ laptop;
  };

  solaire = mkSystem {
    modules =
      [
        ./solaire
      ]
      ++ base
      ++ graphical
      ++ gaming;
  };

  anastacia = mkSystem {
    modules = [
      ./anastacia

      "${self}/config/nixos/services/forgejo.nix"
      "${self}/config/nixos/services/searx.nix"
      "${self}/config/nixos/services/portfolio.nix"
    ];
  };
}
