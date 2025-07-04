{
  lib,
  pkgs,
  config,
  self',
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.name != null) {
    hj = {
      packages = builtins.attrValues {
        inherit
          (self'.packages)
          app2unit
          mcuxpressoide
          ;

        inherit
          (pkgs)
          cinny-desktop
          devenv
          entr
          fastfetch
          fzf
          geary
          hyfetch
          imhex
          logisim-evolution
          obsidian
          playerctl
          proton-pass
          qalculate-gtk
          resources
          simple-scan
          vscode-fhs
          wl-clipboard
          ;
      };

      files = {
        ".config/hyfetch.json".text = toJSON {
          preset = "nonbinary";
          mode = "rgb";
          backend = "fastfetch";
          color_align.mode = "horizontal";
        };
      };
    };
  };
}
