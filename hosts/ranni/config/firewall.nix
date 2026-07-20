{config, ...}: {
  networking.firewall = {
    enable = true;
    allowPing = true;

    allowedUDPPorts = [config.services.tailscale.port];

    allowedTCPPorts = [22 80 443];
  };
}
