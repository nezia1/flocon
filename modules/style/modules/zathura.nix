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
      programs.zathura.options = {
        default-fg = scheme.palette.base01;
        default-bg = scheme.palette.base00;

        completion-bg = scheme.palette.base01;
        completion-fg = scheme.palette.base0D;
        completion-highlight-bg = scheme.palette.base0D;
        completion-highlight-fg = scheme.palette.base07;

        statusbar-fg = scheme.palette.base04;
        statusbar-bg = scheme.palette.base02;

        notification-bg = scheme.palette.base00;
        notification-fg = scheme.palette.base07;
        notification-error-bg = scheme.palette.base00;
        notification-error-fg = scheme.palette.base08;
        notification-warning-bg = scheme.palette.base00;
        notification-warning-fg = scheme.palette.base0A;

        inputbar-fg = scheme.palette.base07;
        inputbar-bg = scheme.palette.base00;

        recolor = false;
        recolor-keephue = false;
        recolor-lightcolor = scheme.palette.base00;
        recolor-darkcolor = scheme.palette.base06;

        highlight-color = scheme.palette.base0A;
        highlight-active-color = scheme.palette.base0D;
      };
    }
  ];
}
