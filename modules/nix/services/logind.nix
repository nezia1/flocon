{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.laptop.enable {
    services.logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey=ignore
        HandlePowerKeyLongPress=poweroff
      '';
    };
  };
}
