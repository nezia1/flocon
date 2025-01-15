{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.local.style;
in {
  imports =
    [
      inputs.niri.nixosModules.niri
      inputs.hyprland.nixosModules.default
    ]
    ++ lib.filesystem.listFilesRecursive ./modules;

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        home.pointerCursor = {
          inherit (cfg.cursorTheme) name package size;
          x11.enable = true;
          gtk.enable = true;
        };
      }
    ];
  };
}
