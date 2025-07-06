{pkgs, ...}: {
  services = {
    caddy = {
      enable = true;
      package = pkgs.caddy;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];

    extraForwardRules = ''
      ip6 saddr { ::/0 } accept
    '';
  };

  networking.enableIPv6 = true;
}
