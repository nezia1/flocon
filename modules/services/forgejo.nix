{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrNames concatStringsSep map readDir toString;
  inherit (lib.modules) mkAfter mkIf;
  inherit (lib.strings) removePrefix removeSuffix;

  alibabaSlop = [
    "47.74.0.0/15"
    "47.76.0.0/14"
    "47.80.0.0/13"
    "8.208.0.0/12"
    "47.235.0.0/16"
    "47.240.0.0/14"
    "47.236.0.0/14"
    "47.246.0.0/16"
    "47.244.0.0/15"
    "8.210.190.0/24"
    "8.210.179.0/24"
    "8.210.147.0/24"
    "8.210.164.0/24"
    "8.210.154.0/24"
    "8.218.91.0/24"
    "8.210.188.0/24"
    "8.210.187.0/24"
    "8.210.176.0/24"
    "8.210.189.0/24"
  ];

  # https://github.com/isabelroses/dotfiles/blob/06f8f70914c8e672541a52563ee624ce2e62adfb/modules/nixos/services/selfhosted/forgejo.nix#L19-L23
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    sha256 = "et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };

  srv = config.services.forgejo.settings.server;
in {
  config = mkIf config.local.profiles.server.enable {
    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        lfs.enable = true;
        database.type = "postgres";
        dump = {
          enable = true;
          type = "tar.xz";
        };
        settings = {
          server = {
            DOMAIN = "git.nezia.dev";
            HTTP_PORT = 1849;
            ROOT_URL = "https://${srv.DOMAIN}/";
            HTTP_ADDR = "localhost";
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
          federation = {
            ENABLED = true;
          };
          ui = {
            DEFAULT_THEME = "catppuccin-mocha-lavender";
            THEMES = concatStringsSep "," (
              ["auto,forgejo-auto,forgejo-dark,forgejo-light,arc-gree,gitea"]
              ++ (map (name: removePrefix "theme-" (removeSuffix ".css" name)) (
                attrNames (readDir theme)
              ))
            );
          };

          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
          };
        };
      };

      caddy = {
        enable = true;
        virtualHosts."git.nezia.dev".extraConfig = ''
          @badbot2 header Referer https://{host}{uri}
          @badbot3 header Referrer https://{host}{uri}
          @badbot `header_regexp('User-Agent','(?i).*(censys|semrush|amazon|microsoft|chatgpt|claude|cohere|facebook|crawler|img2dataset|omgili|peer39|anthropic|bytespider|applebot|baiduspider|bing|msn|adidx|google|slurp|yandex|duckduck|twitter|tweet|copilot).*')
                  || header_regexp('User-Agent','(?i).*(bot\b|-ai\b|bot;|-ai;).*')
                  || header_regexp('Referer','(?i).*(google.com).*') || header_regexp('Referrer','(?i).*(google.com).*')`
          respond @badbot "その目、誰の目？" 200
          respond @badbot2 "その目、誰の目？" 200
          respond @badbot3 "その目、誰の目？" 200

          defender garbage {
              ranges aws openai githubcopilot aws-us-east-1 aws-us-west-1 aws-eu-west-1 gcloud azurepubliccloud ${concatStringsSep " " alibabaSlop}
              serve_ignore
          }
          reverse_proxy * localhost:${toString srv.HTTP_PORT}
        '';
      };
    };

    # https://github.com/isabelroses/dotfiles/blob/06f8f70914c8e672541a52563ee624ce2e62adfb/modules/nixos/services/selfhosted/forgejo.nix#L59-L71
    systemd.services = {
      forgejo = {
        preStart = let
          inherit (config.services.forgejo) stateDir;
        in
          mkAfter ''
            rm -rf ${stateDir}/custom/public/assets
            mkdir -p ${stateDir}/custom/public/assets
            ln -sf ${theme} ${stateDir}/custom/public/assets/css
          '';
        serviceConfig = {
          MemoryHigh = "768M";
          MemoryMax = "1G";
        };
      };
    };
  };
}
