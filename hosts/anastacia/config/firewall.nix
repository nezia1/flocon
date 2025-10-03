{config, ...}: {
  networking.firewall = {
    enable = true;

    trustedInterfaces = ["tailscale0"];

    allowedUDPPorts = [config.services.tailscale.port];

    allowedTCPPorts = [22];
  };
}
