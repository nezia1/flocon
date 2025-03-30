{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.server.enable {
    services = {
      caddy = {
        enable = true;
        package = pkgs.caddy;
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [80 443];

      extraForwardRules = ''
        ip6 saddr { ::/0 } accept
      '';
    };

    networking.enableIPv6 = true;
  };
}
