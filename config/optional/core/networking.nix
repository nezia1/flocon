{config, ...}: {
  networking = {
    inherit (config.local.vars.system) hostName;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };
}
