{inputs, ...}: {
  imports = [inputs.nix-index-db.hmModules.nix-index];
  programs = {
    nix-index = {
      enable = true;
      symlinkToCacheHome = true; # needed for comma
    };
    command-not-found.enable = false;
    nix-index-database.comma.enable = true;
  };
}
