{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop != null) {
    hj.packages = with pkgs;
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
