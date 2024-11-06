{specialArgs, ...}: let
  system = ../../system;
  home = ../../home;
in {
  imports = [
    ./hardware-configuration.nix
    ./modules

    system
    "${system}/hardware/uni-sync.nix"

    "${system}/programs/gnome.nix"
    "${system}/programs/games.nix"
    "${system}/hardware/nvidia.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      home
      "${home}/programs/games"

      "${home}/terminal/emulators/foot.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "solaire";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
