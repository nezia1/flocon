{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
  inherit (cfg) scheme;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.swaylock.settings = {
        inside-color = scheme.palette.base01;
        line-color = scheme.palette.base01;
        ring-color = scheme.palette.base05;
        text-color = scheme.palette.base05;

        inside-clear-color = scheme.palette.base0A;
        line-clear-color = scheme.palette.base0A;
        ring-clear-color = scheme.palette.base00;
        text-clear-color = scheme.palette.base00;

        inside-caps-lock-color = scheme.palette.base03;
        line-caps-lock-color = scheme.palette.base03;
        ring-caps-lock-color = scheme.palette.base00;
        text-caps-lock-color = scheme.palette.base00;

        inside-ver-color = scheme.palette.base0D;
        line-ver-color = scheme.palette.base0D;
        ring-ver-color = scheme.palette.base00;
        text-ver-color = scheme.palette.base00;

        inside-wrong-color = scheme.palette.base08;
        line-wrong-color = scheme.palette.base08;
        ring-wrong-color = scheme.palette.base00;
        text-wrong-color = scheme.palette.base00;

        caps-lock-bs-hl-color = scheme.palette.base08;
        caps-lock-key-hl-color = scheme.palette.base0D;
        bs-hl-color = scheme.palette.base08;
        key-hl-color = scheme.palette.base0D;

        separator-color = "#00000000"; # transparent
        layout-bg-color = "#00000050"; # semi-transparent black
      };
    }
  ];
}
