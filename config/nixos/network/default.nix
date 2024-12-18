{config, ...}: {
  networking = {
    inherit (config.local.systemVars) hostName;
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
}
