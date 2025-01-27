{lib, ...}: {
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
  system.stateVersion = lib.mkDefault "24.05";
  zramSwap.enable = true;
}
