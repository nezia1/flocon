{
  self,
  specialArgs,
  ...
}: let
  mod = "${self}/system";
in {
  imports = [
    ./hardware-configuration.nix
    ./modules

    "${mod}"
    "${mod}/hardware/uni-sync.nix"

    "${mod}/programs/gnome.nix"
    "${mod}/programs/games.nix"
    "${mod}/hardware/nvidia.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${self}/home"
      "${self}/home/programs/games"

      "${self}/home/terminal/emulators/foot.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "solaire";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
