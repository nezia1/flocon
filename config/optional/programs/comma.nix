{inputs, ...}: {
  imports = [inputs.nix-index-database.nixosModules.nix-index];
  config = {
    programs.nix-index-database.comma.enable = true;
  };
}
