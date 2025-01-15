{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
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
