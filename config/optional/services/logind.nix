{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.local.profiles.laptop.enable && config.local.vars.home.desktop.type == "wm") {
    services.logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey=ignore
        HandlePowerKeyLongPress=poweroff
      '';
    };
  };
}
