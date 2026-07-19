{
  services = {
    resolved.enable = false;
    pihole-ftl = {
      enable = true;
      openFirewallDNS = true;
      settings = {
        # See <https://docs.pi-hole.net/ftldns/configfile/>
        dns = {
          listeningMode = "ALL";
          upstreams = ["9.9.9.9"];
          hosts = [
            "192.168.1.50 pihole.home.arpa"
          ];
        };
      };

      lists = [
        # Lists can be added via URL
        {
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
          type = "block";
          enabled = true;
          description = "hagezi blocklist";
        }
        {
          url = "https://raw.githubusercontent.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist/refs/heads/main/noai_hosts.txt";
          type = "block";
          enabled = true;
          description = "ai blocklist";
        }
      ];
    };

    pihole-web = {
      enable = true;
      hostName = "pihole.home.arpa";
      ports = ["18000"];
    };

    caddy.virtualHosts."pihole.home.arpa:443".extraConfig = ''
      reverse_proxy http://127.0.0.1:18000
      tls internal
    '';
  };
}
