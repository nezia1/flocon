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
    "${mod}/core/lanzaboote.nix"

    "${mod}/hardware/fprintd.nix"
    "${mod}/services/power.nix"
    "${mod}/services/brightness.nix"
    "${mod}/services/keyd.nix"

    "${mod}/services/logind.nix"
    "${mod}/services/greetd.nix"

    "${mod}/programs/niri"
    "${mod}/services/gnome.nix"
    "${mod}/services/mail.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${self}/home"
      "${self}/home/services/udiskie.nix"

      "${self}/home/programs/niri"
      "${self}/home/programs/ags"
      "${self}/home/programs/fuzzel.nix"
      "${self}/home/programs/swaybg.nix"
      "${self}/home/programs/swaylock.nix"
      "${self}/home/programs/swayidle.nix"

      "${self}/home/terminal/emulators/foot.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "vamos";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
