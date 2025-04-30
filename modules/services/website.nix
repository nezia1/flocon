{
  lib,
  config,
  inputs',
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.server.enable {
    services.caddy.enable = true;
    services.caddy.virtualHosts = {
      "www.nezia.dev" = {
        extraConfig = ''
          redir https://nezia.dev{uri}
        '';
      };
      "nezia.dev" = {
        extraConfig = ''
          root * ${inputs'."nezia_dev".packages.default}
          file_server
          encode gzip
        '';
      };
    };
  };
}
