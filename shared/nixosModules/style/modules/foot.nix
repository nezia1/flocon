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
      in
        with palette; {
          background = base00;
          foreground = base05;

          regular0 = base00;
          regular1 = base08;
          regular2 = base0B;
          regular3 = base0A;
          regular4 = base0D;
          regular5 = base0E;
          regular6 = base0C;
          regular7 = base05;

          bright0 = base02;
          bright1 = base08;
          bright2 = base0B;
          bright3 = base0A;
          bright4 = base0D;
          bright5 = base0E;
          bright6 = base0C;
          bright7 = base07;

          "16" = base09;
          "17" = base0F;
          "18" = base01;
          "19" = base02;
          "20" = base04;
          "21" = base06;
        };
    }
  ];
}
