{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) toString;

  srv = config.services.firefox-syncserver;
in {
  age.secrets.firefox-sync.file = ../../../secrets/firefox-sync.age;

  services = {
    mysql.package = pkgs.mariadb;

    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets.firefox-sync.path;
      settings = {
        host = "::1";
        port = 8579;

        # Override database URLs to use Unix socket for authentication
        # This allows the firefox-syncserver user to authenticate via unix_socket
        syncstorage.database_url = "mysql://firefox-syncserver@localhost/firefox_syncserver?socket=%2Frun%2Fmysqld%2Fmysqld.sock";
        tokenserver.database_url = "mysql://firefox-syncserver@localhost/firefox_syncserver?socket=%2Frun%2Fmysqld%2Fmysqld.sock";
      };
      logLevel = "info";
      singleNode = rec {
        enable = true;
        hostname = "sync.nezia.dev";
        url = "https://${hostname}";
      };
    };

    caddy = {
      enable = true;
      virtualHosts."${srv.singleNode.hostname}".extraConfig = ''
        tls {
          resolvers 1.1.1.1
          dns porkbun {
            api_key {$PORKBUN_API_KEY}
            api_secret_key {$PORKBUN_SECRET_KEY}
          }
        }

        reverse_proxy http://[${srv.settings.host}]:${toString srv.settings.port}
      '';
    };
  };

  users = {
    users.firefox-syncserver = {
      group = "firefox-syncserver";
      isSystemUser = true;
      extraGroups = ["mysql"];
    };
    groups.firefox-syncserver.members = ["firefox-syncserver"];
  };
}
