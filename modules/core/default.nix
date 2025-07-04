{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  system.stateVersion = mkDefault "24.05";
  zramSwap.enable = true;
}
