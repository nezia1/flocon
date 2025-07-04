{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep map toJSON;
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatMapStringsSep;
  inherit (config.local.vars.system) username;

  styleCfg = config.local.style;

  mkLayout = items:
    concatStringsSep "\n" (map toJSON items);

  # thanks https://github.com/fufexan/dotfiles/blob/eb3f1cc008b2410aed885b9462e4fbfe47f1bb8e/home/programs/wayland/wlogout.nix#L6-L10
  bgImageSection = name: ''
    #${name} {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
    }
  '';
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    hj = {
      packages = [pkgs.wlogout];
      files = {
        ".config/wlogout/layout".text = let
          loginctl = getExe' pkgs.systemd "loginctl";
          systemctl = getExe' pkgs.systemd "systemctl";
        in
          mkLayout [
            {
              action = "${loginctl} lock-session";
              keybind = "l";
              label = "lock";
              text = "Lock";
            }

            {
              action = "${systemctl} hibernate";
              keybind = "h";
              label = "hibernate";
              text = "Hibernate";
            }

            {
              action = "${loginctl} terminate-user ${username}";

              keybind = "q";
              label = "logout";
              text = "Logout";
            }

            {
              action = "${systemctl} poweroff";
              keybind = "p";
              label = "shutdown";
              text = "Shutdown";
            }

            {
              action = "${systemctl} suspend";
              keybind = "s";
              label = "suspend";
              text = "Suspend";
            }

            {
              action = "${systemctl} reboot";
              keybind = "r";
              label = "reboot";
              text = "Reboot";
            }
          ];

        ".config/wlogout/style.css".text = with styleCfg.colors.scheme.withHashtag;
          mkIf styleCfg.enable
          /*
          css
          */
          ''
            window {
              font-size: 18px;
              background-color: alpha(${base00}, 0.8);
              color: ${base05};
            }
            button {
              background-repeat: no-repeat;
              background-position: center;
              background-size: 25%;
              border: none;
              background-color: alpha(${base00}, 0);
              color: ${base0E};
            }
            button:hover {
              background-color: alpha(${base02}, 0.1);
            }
            button:focus {
              background-color: ${base0E};
              color: ${base00};
            }

            ${concatMapStringsSep "\n" bgImageSection [
              "lock"
              "logout"
              "suspend"
              "hibernate"
              "shutdown"
              "reboot"
            ]}
          '';
      };
    };
  };
}
