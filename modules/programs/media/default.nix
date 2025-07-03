{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.name != null) {
    hj.packages =
      builtins.attrValues
      ({
          inherit
            (pkgs)
            spotify
            stremio
            tidal-hifi
            ;
        }
        // (optionalAttrs (config.local.vars.home.desktop.type == "wm") {
          inherit
            (pkgs)
            celluloid
            gthumb
            papers
            ;
        }));
  };
}
