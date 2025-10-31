{
  config,
  pkgs,
  ...
}: let
  caddy = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/caddy-dns/porkbun@v0.3.1"
    ];
    hash = "sha256-j/GODingW5BhfjQRajinivX/9zpiLGgyxvAjX0+amRU=";
  };
in {
  age.secrets = {
    porkbun.file = ../../../secrets/porkbun.age;
  };
  services = {
    caddy = {
      enable = true;
      package = caddy;
      email = "anthony@nezia.dev";
    };
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.porkbun.path;
}
