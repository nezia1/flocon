{
  config,
  pkgs,
  ...
}: let
  caddy = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/caddy-dns/porkbun@v0.3.1"
    ];
    hash = "sha256-BKUsUoBE1IjnD9Xu8kTVkbRqqk2qvNtFDD/pvVkfRmI=";
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
