{
  lib,
  pkgs,
  config,
  pins,
  ...
}: let
  inherit (lib) mkIf;

  styleCfg = config.local.style;
  discord = pkgs.vesktop.override {
    withTTS = false;
    withSystemVencord = true;
  };

  base16-discord = pkgs.concatTextFile {
    name = "base16-discord.css";
    files = with styleCfg.colors.scheme.palette; [
      "${pins.base16-discord}/base16.css"
      (builtins.toFile "base16.css"
        ''
          :root {
              --base00: ${base00};
              --base01: ${base01};
              --base02: ${base02};
              --base03: ${base03};
              --base04: ${base04};
              --base05: ${base05};
              --base06: ${base06};
              --base07: ${base07};
              --base08: ${base08};
              --base09: ${base09};
              --base0A: ${base0A};
              --base0B: ${base0B};
              --base0C: ${base0C};
              --base0D: ${base0D};
              --base0E: ${base0E};
              --base0F: ${base0F};
          }
        '')
    ];
  };
in {
  config = mkIf (config.local.vars.home.desktop != null) {
    hj = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
      files.".config/vesktop/themes/base16.css".source = mkIf styleCfg.enable base16-discord;
    };
  };
}
