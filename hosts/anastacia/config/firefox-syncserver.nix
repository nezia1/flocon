{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
in {
  age.secrets.firefox-sync.file = ../../../secrets/firefox-sync.age;
  services = {
    mysql.package = pkgs.mariadb;
    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets.firefox-sync.path;
      settings = {
        host = "0.0.0.0";
        port = 8579;
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
      virtualHosts."sync.nezia.dev".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.firefox-syncserver.settings.port} {
          header_up Host {upstream_hostport}
        }
      '';
    };
  };
}
