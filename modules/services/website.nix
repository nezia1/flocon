{
  lib,
  flakePkgs,
  config,
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
          root * ${flakePkgs.inputs."nezia_dev".default}
          file_server
          encode gzip
        '';
      };
    };
  };
}
