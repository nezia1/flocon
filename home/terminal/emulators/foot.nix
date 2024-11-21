{
  osConfig,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=14";
        shell = "${lib.getExe config.programs.fish.package}";
      };
      colors = mkIf osConfig.theme.enable (let
        inherit (lib) mapAttrs;
        inherit (lib.strings) removePrefix;
        # because someone thought this was a great idea: https://github.com/tinted-theming/schemes/commit/61058a8d2e2bd4482b53d57a68feb56cdb991f0b
        palette = mapAttrs (_: color: removePrefix "#" color) osConfig.theme.scheme.palette;
      in {
        background = palette.base00;
        foreground = palette.base05;

        regular0 = palette.base01;
        regular1 = palette.base08;
        regular2 = palette.base0B;
        regular3 = palette.base0A;
        regular4 = palette.base0D;
        regular5 = palette.base0E;
        regular6 = palette.base0C;
        regular7 = palette.base06;

        bright0 = palette.base02;
        bright1 = palette.base08;
        bright2 = palette.base0B;
        bright3 = palette.base0A;
        bright4 = palette.base0D;
        bright5 = palette.base0E;
        bright6 = palette.base0C;
        bright7 = palette.base07;
      });
    };
  };
}
