{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      wayland.windowManager.hyprland.settings = {
        env = [
          "HYPRCURSOR_THEME,phinger-cursors-light"
          "HYPRCURSOR_SIZE,32"
          "XCURSOR_SIZE,32"
        ];
        general = {
          border_size = 4;
          "col.active_border" = "rgb(${lib.removePrefix "#" cfg.scheme.palette.base0E})";
        };
        decoration = {
          rounding = 10;
          blur.enabled = true;
        };
      };
    }
  ];
}
