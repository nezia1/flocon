{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  port = "9999";
in {
  config = mkIf config.local.profiles.server.enable {
    services = {
      uptime-kuma = {
        enable = true;
        settings = {PORT = port;};
      };

      caddy.virtualHosts."uptime.nezia.dev".extraConfig = ''
        reverse_proxy localhost:${port}
      '';
    };
  };
}
