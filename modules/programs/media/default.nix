{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;

  inherit (config.local.vars.system) username;
in {
  config = mkIf (config.local.vars.home.desktop != "none") {
    hjem.users.${username}.packages = with pkgs;
      [
        spotify
        stremio
        tidal-hifi
      ]
      ++ (optionals (config.local.vars.home.desktop == "Hyprland") [
        celluloid
        gthumb
        papers
      ]);
  };
}
