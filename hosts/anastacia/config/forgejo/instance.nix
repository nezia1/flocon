{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrNames concatStringsSep map readDir;
  inherit (lib.modules) mkAfter;
  inherit (lib.strings) removePrefix removeSuffix;

  # https://github.com/isabelroses/dotfiles/blob/06f8f70914c8e672541a52563ee624ce2e62adfb/modules/nixos/services/selfhosted/forgejo.nix#L19-L23
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    sha256 = "et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };

  srv = config.services.forgejo.settings.server;
in {
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
          ROOT_URL = "https://${srv.DOMAIN}/";
          HTTP_ADDR = "::1";
          HTTP_PORT = 3000;
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
        security = {
          PASSWORD_HASH_ALGO = "argon2";
          REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8,::1/128";
        };

        actions.ENABLED = true;
      };
    };

    caddy = {
      enable = true;
      virtualHosts."${srv.DOMAIN}".extraConfig = ''
        tls {
          resolvers 1.1.1.1
          dns porkbun {
            api_key {$PORKBUN_API_KEY}
            api_secret_key {$PORKBUN_SECRET_KEY}
          }
        }

        reverse_proxy http://${srv.HTTP_ADDR}:${toString srv.HTTP_PORT} {
          header_up X-Real-Ip {remote_host}
        }
      '';
    };
  };

  # https://github.com/DarkKirb/nixos-config/blob/9259583284caf5c051aa521151c0ba1d520aa931/services/forgejo/default.nix#L8-L22
  # https://github.com/isabelroses/dotfiles/blob/06f8f70914c8e672541a52563ee624ce2e62adfb/modules/nixos/services/selfhosted/forgejo.nix#L59-L71
  systemd.services.forgejo = {
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
}
