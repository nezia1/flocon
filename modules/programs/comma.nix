{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) desktop;
in {
  imports = [inputs.nix-index-database.nixosModules.nix-index];
  config = mkIf desktop.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
