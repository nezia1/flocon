{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.foot.settings.colors = let
        # because someone thought this was a great idea: https://github.com/tinted-theming/schemes/commit/61058a8d2e2bd4482b53d57a68feb56cdb991f0b
        palette = builtins.mapAttrs (_: color: lib.removePrefix "#" color) cfg.scheme.palette;
      in {
        background = palette.base00;
        foreground = palette.base05;

        regular0 = palette.base00;
        regular1 = palette.base08;
        regular2 = palette.base0B;
        regular3 = palette.base0A;
        regular4 = palette.base0D;
        regular5 = palette.base0E;
        regular6 = palette.base0C;
        regular7 = palette.base05;

        bright0 = palette.base02;
        bright1 = palette.base08;
        bright2 = palette.base0B;
        bright3 = palette.base0A;
        bright4 = palette.base0D;
        bright5 = palette.base0E;
        bright6 = palette.base0C;
        bright7 = palette.base07;

        "16" = palette.base09;
        "17" = palette.base0F;
        "18" = palette.base01;
        "19" = palette.base02;
        "20" = palette.base04;
        "21" = palette.base06;
      };
    }
  ];
}
