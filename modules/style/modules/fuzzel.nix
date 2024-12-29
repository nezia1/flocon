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
        colors = with scheme.palette; {
          background = "${base01}f2";
          text = "${base05}ff";
          match = "${base0E}ff";
          selection = "${base03}ff";
          selection-text = "${base06}ff";
          selection-match = "${base0E}ff";
          border = "${base0E}ff";
        };
      };
    }
  ];
}
