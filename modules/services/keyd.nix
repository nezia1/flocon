{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings.main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };
}
