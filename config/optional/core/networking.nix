{config, ...}: {
  networking = {
    inherit (config.local.vars.system) hostName;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
      };
      dns = "systemd-resolved";
    };
  };
  services.resolved.enable = true;
}
