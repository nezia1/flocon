{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    networking = {
      inherit (config.local.vars.system) hostName;
      nameservers = ["1.1.1.1" "1.0.0.1"];
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        wifi.powersave = true;
      };
    };
    services.resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };
}
