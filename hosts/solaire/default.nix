{
  inputs,
  specialArgs,
  ...
}: let
  nixos = "${inputs.self}/config/nixos";
  hm = "${inputs.self}/config/home-manager";
in {
  local.systemVars = {
    hostName = "solaire";
    username = "nezia";
  };

  local.homeVars = {
    fullName = "Anthony Rodriguez";
    email = "anthony@nezia.dev";
  };

  imports = [
    ./hardware-configuration.nix
    ./config/nvidia.nix
    ./config/theme.nix

    nixos
    "${nixos}/hardware/uni-sync.nix"

    "${nixos}/services/logind.nix"
    "${nixos}/services/greetd.nix"

    "${nixos}/programs/hyprland.nix"
    "${nixos}/services/gnome.nix"

    "${nixos}/programs/games.nix"

    "${nixos}/services/documentation.nix"

    "${nixos}/services/flatpak.nix"
    "${nixos}/services/location.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      hm
      "${hm}/services/udiskie.nix"
      "${hm}/programs/games"

      "${hm}/programs/waybar"
      "${hm}/programs/fuzzel.nix"
      "${hm}/programs/hypr"

      "${hm}/services/swaync"
      "${hm}/programs/hypr/paper.nix"

      "${hm}/terminal/emulators/foot.nix"

      "${hm}/services/flatpak.nix"
      "${hm}/services/syncthing.nix"
      "${hm}/services/gammastep.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
