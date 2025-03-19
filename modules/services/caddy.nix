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
        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/jasonlovesdoggo/caddy-defender@v0.7.0"];
          hash = "sha256-VP2APliPadFdKFCizSWoBEAA00M8DV+BBAiPf3XjgY0=";
        };
        globalConfig = ''
          debug
          order defender after header
        '';
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [80 443];

      # if using nftables
      extraForwardRules = ''
        ip6 saddr { ::/0 } accept
      '';
    };

    # ensure IPv6 is enabled
    networking.enableIPv6 = true;
  };
}
