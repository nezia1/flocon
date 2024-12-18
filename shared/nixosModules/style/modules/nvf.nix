{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.nvf.settings.vim.theme = {
        enable = true;
        name = "base16";
        base16-colors = cfg.scheme.palette;
      };
    }
  ];
}
