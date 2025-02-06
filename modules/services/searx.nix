{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = lib.mkIf config.local.profiles.server.enable {
    age.secrets.searx-env-file.file = ../../secrets/searx-env-file.age;
    services = {
      searx = {
        enable = true;
        package = pkgs.searxng;
        environmentFile = config.age.secrets.searx-env-file.path;
        settings = {
          search = {
            safe_search = 1; # 0 = None, 1 = Moderate, 2 = Strict
            autocomplete = "google"; # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
            default_lang = "en";
          };
          server = {
            secret_key = "@SEARX_SECRET_KEY@";
            port = 8888; # Internal port
            bind_address = "localhost"; # Only listen locally
            base_url = "https://search.nezia.dev/";
            image_proxy = true;
            default_http_headers = {
              X-Content-Type-Options = "nosniff";
              X-XSS-Protection = "1; mode=block";
              X-Download-Options = "noopen";
              X-Robots-Tag = "noindex, nofollow";
              Referrer-Policy = "no-referrer";
            };
          };
          engines = [
            {
              name = "qwant";
              disabled = true;
            }
          ];
        };
      };

      caddy = {
        enable = true;
        virtualHosts."search.nezia.dev" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost:8888 {
              header_up Host {host}
              header_up X-Real-IP {remote_addr}
              header_up X-Forwarded-For {remote_addr}
              header_up X-Forwarded-Proto {scheme}
            }
          '';
        };
      };
    };

    # Open required ports
    networking.firewall = {
      allowedTCPPorts = [80 443]; # For Caddy
    };
  };
}
