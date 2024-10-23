{
  config,
  pkgs,
  ...
}: let
  srv = config.services.forgejo.settings.server;
in {
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      lfs.enable = true;
      database.type = "postgres";
      dump = {
        enable = true;
        type = "tar.xz";
      };
      settings = {
        server = {
          DOMAIN = "git.nezia.dev";
          HTTP_PORT = 1849;
          ROOT_URL = "https://${srv.DOMAIN}/";
          HTTP_ADDR = "localhost";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
        federation = {
          ENABLED = true;
        };
      };
    };

    caddy = {
      enable = true;
      virtualHosts."git.nezia.dev".extraConfig = ''
        reverse_proxy * localhost:${toString srv.HTTP_PORT}
      '';
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];

    # If you're using nftables (default in newer NixOS)
    extraForwardRules = ''
      ip6 saddr { ::/0 } accept
    '';
  };

  # Ensure IPv6 is enabled
  networking.enableIPv6 = true;
}
