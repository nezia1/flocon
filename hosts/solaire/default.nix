{
  inputs,
  specialArgs,
  ...
}: let
  system = "${inputs.self}/system";
  home = "${inputs.self}/home";
in {
  imports = [
    ./hardware-configuration.nix
    ./modules

    system
    "${system}/hardware/uni-sync.nix"

    "${system}/programs/games.nix"
    "${system}/hardware/nvidia.nix"

    "${system}/services/logind.nix"
    "${system}/services/greetd.nix"

    "${system}/programs/hyprland.nix"
    "${system}/services/gnome.nix"

    "${system}/services/documentation.nix"

    "${system}/services/flatpak.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${home}"
      "${home}/services/udiskie.nix"
      "${home}/programs/games"

      "${home}/programs/waybar"
      "${home}/programs/fuzzel.nix"
      "${home}/programs/hypr"

      "${home}/services/swaync"
      "${home}/programs/swaybg.nix"
      "${home}/programs/swaylock.nix"

      "${home}/terminal/emulators/foot.nix"

      "${home}/services/flatpak.nix"
      "${home}/services/syncthing.nix"

      "${home}/programs/editors/neovim.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "solaire";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
