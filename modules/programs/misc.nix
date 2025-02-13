{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        entr
        fastfetch
        fractal
        fzf
        geary
        hyfetch
        imhex
        logisim-evolution
        mission-center
        obsidian
        playerctl
        proton-pass
        simple-scan
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
