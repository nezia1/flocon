{
  self,
  specialArgs,
  ...
}: let
  mod = "${self}/system";
in {
  imports = [
    ./hardware-configuration.nix

    "${mod}"
    "${mod}/hardware/uni-sync.nix"

    "${mod}/programs/gnome.nix"
    "${mod}/programs/games.nix"
    "${mod}/hardware/nvidia.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${self}/home"
      "${self}/home/services/udiskie.nix"

      "${self}/home/programs"

      "${self}/home/terminal/emulators/foot.nix"
      "${self}/home/programs/editors/neovim.nix"
      "${self}/home/programs/editors/helix.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "solaire";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
