{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf (config.local.homeVars.desktop != "none") {
    hjem.users.${username} = {
      packages = with pkgs; [
        inputs.self.packages.${pkgs.system}.app2unit
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
