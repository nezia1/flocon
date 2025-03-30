{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrNames concatStringsSep map readDir toString;
  inherit (lib.modules) mkAfter mkIf;
  inherit (lib.strings) removePrefix removeSuffix;

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
          security = {
            PASSWORD_HASH_ALGO = "argon2";
            REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8,::1/128";
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
          reverse_proxy http://localhost${config.systemd.services.anubis-forgejo.environment.BIND} {
            header_up X-Real-Ip {remote_host}
          }
        '';
      };
    };

    # https://github.com/DarkKirb/nixos-config/blob/9259583284caf5c051aa521151c0ba1d520aa931/services/forgejo/default.nix#L8-L22
    systemd.services.anubis-forgejo = {
      description = "scrape protection for forgejo";
      requires = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.anubis}/bin/anubis";
      };
      environment = {
        BIND = ":60927";
        METRICS_BIND = ":29397";
        TARGET = "http://${srv.HTTP_ADDR}:${toString srv.HTTP_PORT}";
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
