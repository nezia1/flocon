{
  lib,
  pkgs,
  config,
  flakePkgs,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop != "none") {
    hj = {
      packages = with pkgs; [
        flakePkgs.self.app2unit
        devenv
        entr
        fastfetch
        fractal
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
      ];

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
