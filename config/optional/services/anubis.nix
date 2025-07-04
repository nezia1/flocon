{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.server.enable {
    services.anubis = {
      defaultOptions = {
        botPolicy = {dnsbl = false;};
        settings = {
          DIFFICULTY = 4;
          SERVE_ROBOTS_TXT = true;
        };
      };
    };
  };
}
