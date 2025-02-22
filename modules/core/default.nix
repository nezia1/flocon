{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  imports = [
    ./hardware

    ./boot.nix
    ./fonts.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
    ./security.nix
  ];
  system.stateVersion = mkDefault "24.05";
  zramSwap.enable = true;
}
