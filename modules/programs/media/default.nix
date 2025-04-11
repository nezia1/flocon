{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf (config.local.homeVars.desktop != "none") {
    hjem.users.${username}.packages = with pkgs;
      [
        spotify
        stremio
        tidal-hifi
      ]
      ++ (optionals (config.local.homeVars.desktop == "Hyprland") [
        celluloid
        gthumb
        papers
      ]);
  };
}
