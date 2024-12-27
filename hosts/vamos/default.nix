{
  inputs,
  specialArgs,
  ...
}: let
  nixos = "${inputs.self}/config/nixos";
  hm = "${inputs.self}/config/home-manager";
in {
  local.systemVars = {
    hostName = "vamos";
    username = "nezia";
  };

  local.homeVars = {
    fullName = "Anthony Rodriguez";
    email = "anthony@nezia.dev";
  };

  imports = [
    ./hardware-configuration.nix
    ./config/theme.nix

    "${nixos}"
    "${nixos}/core/lanzaboote.nix"

    "${nixos}/hardware/fprintd.nix"
    "${nixos}/hardware/mcuxpresso.nix"
    "${nixos}/services/power.nix"
    "${nixos}/services/brightness.nix"

    "${nixos}/services/logind.nix"
    "${nixos}/services/greetd.nix"
    "${nixos}/services/kanata.nix"

    "${nixos}/programs/hyprland.nix"
    "${nixos}/services/gnome.nix"
    "${nixos}/services/mail.nix"

    "${nixos}/services/documentation.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${hm}"
      "${hm}/services/udiskie.nix"

      "${hm}/programs/hypr"
      "${hm}/programs/waybar"
      "${hm}/programs/fuzzel.nix"

      "${hm}/services/swaync"
      "${hm}/programs/hypr/paper.nix"
      "${hm}/programs/wlogout.nix"

      "${hm}/services/syncthing.nix"

      "${hm}/terminal/emulators/foot.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
