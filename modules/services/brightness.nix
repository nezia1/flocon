{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.profiles.laptop.enable && config.local.vars.home.desktop.type == "wm") {
    hardware.brillo.enable = true;
  };
}
