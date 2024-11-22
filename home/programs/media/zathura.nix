{
  osConfig,
  lib,
  lib',
  ...
}: let
  inherit (osConfig.theme.scheme) palette;
  inherit (lib) mkIf mkMerge;
  inherit (lib') rgba;
in {
  programs.zathura = {
    enable = true;
    options = mkMerge [
      {
        font = "Inter 12";
        selection-notification = true;

        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = "1";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
        zoom-min = "10";
      }
      (mkIf osConfig.theme.enable {
        default-fg = palette.base05;
        default-bg = palette.base00;

        completion-bg = palette.base02;
        completion-fg = palette.base05;
        completion-highlight-bg = palette.base03;
        completion-highlight-fg = palette.base05;
        completion-group-bg = palette.base02;
        completion-group-fg = palette.base0D;

        statusbar-fg = palette.base05;
        statusbar-bg = palette.base02;

        notification-bg = palette.base02;
        notification-fg = palette.base05;
        notification-error-bg = palette.base02;
        notification-error-fg = palette.base08;
        notification-warning-bg = palette.base02;
        notification-warning-fg = palette.base0A;

        inputbar-fg = palette.base05;
        inputbar-bg = palette.base02;

        recolor = true;
        recolor-lightcolor = palette.base00;
        recolor-darkcolor = palette.base05;

        index-fg = palette.base05;
        index-bg = palette.base00;
        index-active-fg = palette.base05;
        index-active-bg = palette.base02;

        render-loading-bg = palette.base00;
        render-loading-fg = palette.base05;

        highlight-color = rgba lib palette.base03 ".5";
        highlight-fg = rgba lib palette.base0E ".5";
        highlight-active-color = rgba lib palette.base0E ".5";
      })
    ];
  };
}
