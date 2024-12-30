{inputs, ...}: let
  lib' = import ../shared/lib inputs.nixpkgs.lib;
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs lib';};
      modules = [../shared/nixosModules] ++ (args.modules or []);
    };

  base = [
    ../config/nixos
    ../config/nixos/core/home-manager.nix

    ../config/nixos/services/documentation.nix

    ../config/nixos/services/location.nix

    ({
      config,
      specialArgs,
      ...
    }: {
      home-manager = {
        users.${config.local.systemVars.username}.imports = [
          ../config/home-manager

          ../config/home-manager/services/udiskie.nix
          ../config/home-manager/services/syncthing.nix
        ];

        extraSpecialArgs = specialArgs;
      };
    })
  ];

  graphical = [
    ../config/nixos/services/logind.nix
    ../config/nixos/services/greetd.nix

    ../config/nixos/programs/hyprland.nix
    ../config/nixos/services/gnome.nix
    ({config, ...}: {
      home-manager.users.${config.local.systemVars.username}.imports = [
        ../config/home-manager/programs/waybar
        ../config/home-manager/programs/fuzzel.nix
        ../config/home-manager/programs/hypr
        ../config/home-manager/programs/wlogout.nix

        ../config/home-manager/services/swaync

        ../config/home-manager/terminal/emulators/foot.nix
        ../config/home-manager/services/gammastep.nix
      ];
    })
  ];

  gaming = [
    ../config/nixos/programs/games.nix
    ({config, ...}: {
      home-manager.users.${config.local.systemVars.username}.imports = [
        ../config/home-manager/programs/games
        ../config/home-manager/services/flatpak.nix
      ];
    })
  ];

  laptop = [
    ../config/nixos/core/lanzaboote.nix

    ../config/nixos/hardware/fprintd.nix
    ../config/nixos/services/kanata.nix
    ../config/nixos/services/power.nix
    ../config/nixos/services/brightness.nix

    ../config/nixos/hardware/mcuxpresso.nix
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

      ../config/nixos/services/forgejo.nix
      ../config/nixos/services/searx.nix
      ../config/nixos/services/portfolio.nix
    ];
  };
}
