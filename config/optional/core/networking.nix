{config, ...}: {
  networking = {
    inherit (config.local.vars.system) hostName;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
      dns = "systemd-resolved";
    };
    wireless.iwd.settings = {
      Network.EnableIPv6 = true;
      Settings.AutoConnect = true;
      General.AddressRandomization = "network";
    };
  };
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };
}
