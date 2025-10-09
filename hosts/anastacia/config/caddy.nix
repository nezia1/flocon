{
  config,
  pkgs,
  ...
}: let
  caddy = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/caddy-dns/porkbun@v0.3.1"
    ];
    hash = "sha256-1UyHT1Nhe1FliL2udRjWC1OGUpOewcKRVT89Q5trVdA=";
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
