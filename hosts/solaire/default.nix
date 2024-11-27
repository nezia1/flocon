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

    "${system}/programs/gnome.nix"
    "${system}/programs/games.nix"
    "${system}/hardware/nvidia.nix"

    "${system}/services/documentation.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      home
      "${home}/programs/games"

      "${home}/terminal/emulators/foot.nix"
      "${home}/programs/gnome"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "solaire";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
