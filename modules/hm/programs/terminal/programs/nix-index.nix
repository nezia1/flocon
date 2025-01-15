{
  lib,
  inputs,
  osConfig,
  ...
}: {
  imports = [inputs.nix-index-db.hmModules.nix-index];

  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs = {
      nix-index = {
        enable = true;
        symlinkToCacheHome = true; # needed for comma
      };
      command-not-found.enable = false;
      nix-index-database.comma.enable = true;
    };
  };
}
