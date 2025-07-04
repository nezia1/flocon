{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  imports = [inputs.nix-index-database.nixosModules.nix-index];
  config = mkIf (!config.local.profiles.server.enable) {
    programs.nix-index-database.comma.enable = true;
  };
}
