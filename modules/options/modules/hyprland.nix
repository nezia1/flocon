{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.local.modules.hyprland = {
    enable = mkEnableOption "Hyprland modules";
  };
}
