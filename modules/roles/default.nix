{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.local.roles = {
    desktop.enable = mkEnableOption ''
      Desktop profile.

      Enables everything needed for typical desktop use, such as compositor, display manager etc.
    '';
    gaming.enable = mkEnableOption ''
      Gaming profile.

      Enables utilities and software needed for gaming, such as steam, lutris, proton.
    '';
  };
}
