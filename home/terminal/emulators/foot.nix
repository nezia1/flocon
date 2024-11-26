{
  osConfig,
  config,
  lib,
  ...
}: let
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=14";
        shell = "${lib.getExe config.programs.fish.package}";
      };
    };
  };
}
