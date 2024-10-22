{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = lib.getExe pkgs.foot;
        use-bold = true;
        dpi-aware = "auto";
        font = "monospace:size=14";
      };
      colors = let
        inherit (inputs.basix.schemeData.base16.${osConfig.theme.scheme}) palette;
      in {
        background = "${palette.base00}ff";
        text = "${palette.base05}ff";
        input = "${palette.base05}ff";
        selection = "${palette.base02}ff";
        selection-text = "${palette.base07}ff";
        selection-match = "${palette.base0D}ff";
        border = "${palette.base0E}ff";
      };
      border.width = 5;
    };
  };
}
