{
  inputs,
  osConfig,
  config,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=14";
        shell = "${lib.getExe config.programs.fish.package}";
      };
      colors = let
        schemeData = inputs.basix.schemeData.base16.${osConfig.theme.scheme};
      in {
        background = schemeData.palette.base00;
        foreground = schemeData.palette.base05;

        regular0 = schemeData.palette.base01;
        regular1 = schemeData.palette.base08;
        regular2 = schemeData.palette.base0B;
        regular3 = schemeData.palette.base0A;
        regular4 = schemeData.palette.base0D;
        regular5 = schemeData.palette.base0E;
        regular6 = schemeData.palette.base0C;
        regular7 = schemeData.palette.base06;

        bright0 = schemeData.palette.base02;
        bright1 = schemeData.palette.base08;
        bright2 = schemeData.palette.base0B;
        bright3 = schemeData.palette.base0A;
        bright4 = schemeData.palette.base0D;
        bright5 = schemeData.palette.base0E;
        bright6 = schemeData.palette.base0C;
        bright7 = schemeData.palette.base07;
      };
    };
  };
}
