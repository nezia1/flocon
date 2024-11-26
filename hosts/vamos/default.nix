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

    "${system}"
    "${system}/core/lanzaboote.nix"

    "${system}/hardware/fprintd.nix"
    "${system}/services/power.nix"
    "${system}/services/brightness.nix"

    "${system}/services/logind.nix"
    "${system}/services/greetd.nix"
    "${system}/services/kanata.nix"

    "${system}/programs/niri"
    "${system}/services/gnome.nix"
    "${system}/services/mail.nix"

    "${system}/services/syncthing.nix"
  ];

  home-manager = {
    users.nezia.imports = [
      "${home}"
      "${home}/services/udiskie.nix"

      "${home}/programs/niri"
      "${home}/programs/waybar"
      "${home}/services/swaync"
      "${home}/programs/fuzzel.nix"
      "${home}/programs/swaybg.nix"
      "${home}/programs/swaylock.nix"
      "${home}/programs/swayidle.nix"

      "${home}/terminal/emulators/foot.nix"
    ];
    extraSpecialArgs = specialArgs;
  };

  networking.hostName = "vamos";
  environment.variables.FLAKE = "/home/nezia/.dotfiles";
}
