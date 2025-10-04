{config, ...}: let
  inherit (builtins) toString;
  port = 5000;

  cfg = config.services.harmonia;
in {
  age.secrets = {
    harmonia.file = ../../../secrets/harmonia.age;
  };

  services = {
    harmonia = {
      enable = true;
      signKeyPaths = [config.age.secrets.harmonia.path];
      settings.bind = "[::]:${toString port}";
    };

    caddy = {
      enable = true;
      virtualHosts."cache.nezia.dev".extraConfig = ''
        tls {
          resolvers 1.1.1.1
          dns porkbun {
            api_key {$PORKBUN_API_KEY}
            api_secret_key {$PORKBUN_SECRET_KEY}
          }
        }

        reverse_proxy ${cfg.settings.bind}
      '';
    };
  };

  nix.settings.allowed-users = [config.systemd.services.harmonia.serviceConfig.User];
}
