{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.local.modules.nvidia = {
    enable = mkEnableOption "nvidia";
  };
}
