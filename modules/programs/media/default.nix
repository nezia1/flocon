{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.name != null) {
    hj.packages = with pkgs;
      [
        spotify
        stremio
        tidal-hifi
      ]
      ++ (optionals (config.local.vars.home.desktop.type == "wm") [
        celluloid
        gthumb
        papers
      ]);
  };
}
