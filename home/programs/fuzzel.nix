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
      border.width = 5;
    };
  };
}
