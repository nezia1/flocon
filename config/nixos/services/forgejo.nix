{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkAfter removePrefix removeSuffix;
  srv = config.services.forgejo.settings.server;

  # https://github.com/isabelroses/dotfiles/blob/06f8f70914c8e672541a52563ee624ce2e62adfb/modules/nixos/services/selfhosted/forgejo.nix#L19-L23
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    sha256 = "et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };
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
          THEMES = builtins.concatStringsSep "," (
            ["auto,forgejo-auto,forgejo-dark,forgejo-light,arc-gree,gitea"]
            ++ (map (name: removePrefix "theme-" (removeSuffix ".css" name)) (
              builtins.attrNames (builtins.readDir theme)
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
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];

    # If you're using nftables (default in newer NixOS)
    extraForwardRules = ''
      ip6 saddr { ::/0 } accept
    '';
  };

  # Ensure IPv6 is enabled
  networking.enableIPv6 = true;
}
