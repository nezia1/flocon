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
      programs.fuzzel.settings = {
        main = {
          font = "sans-serif:size=16";
        };
        colors = {
          background = "${scheme.palette.base01}f2";
          text = "${scheme.palette.base05}ff";
          match = "${scheme.palette.base0E}ff";
          selection = "${scheme.palette.base03}ff";
          selection-text = "${scheme.palette.base06}ff";
          selection-match = "${scheme.palette.base0E}ff";
          border = "${scheme.palette.base0E}ff";
        };
      };
    }
  ];
}
