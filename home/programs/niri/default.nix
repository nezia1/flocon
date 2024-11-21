{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkMerge mkIf;
in {
  imports = [./binds.nix];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.gnome-keyring];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };
  };

  programs.niri = mkMerge [
    {
      settings = {
        input = {
          power-key-handling.enable = false;
          keyboard.xkb = {
            layout = "us";
            options = "compose:ralt";
          };
        };

        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;

        layout = {
          focus-ring = {
            enable = true;
          };
          always-center-single-column = true;
        };

        # https://github.com/sodiboo/system/blob/2978f4d79c51a5bd7e38a9cd75e3ec9046aa7e75/niri.mod.nix#L418-L434
        outputs = let
          cfg = config.programs.niri.settings.outputs;
        in {
          "HDMI-A-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.0;
            };
            position.x = -cfg."HDMI-A-1".mode.width;
            position.y = 0;
          };
          "DP-1" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 144.0;
            };
            position.x = 0;
            position.y = 0;
          };
        };

        window-rules = [
          {
            draw-border-with-background = false;
            geometry-corner-radius = let
              r = 8.0;
            in {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              {app-id = "foot";}
            ];
            default-column-width = {proportion = 0.5;};
          }
        ];

        environment = {
          "NIXOS_OZONE_WL" = "1";
          "DISPLAY" = ":0";
          "_JAVA_AWT_WM_NONREPARENTING" = "1"; # https://wiki.archlinux.org/title/Sway#Java_applications
        };
      };
    }
    (mkIf osConfig.theme.enable (let
      inherit (osConfig.theme.scheme) palette;
    in {
      layout.focus-ring.active.color = palette.base0E;
    }))
  ];

  # copied from https://github.com/linyinfeng/dotfiles/blob/c00fe3b1562ad947672863a43e455bc2f01a56b6/home-manager/profiles/niri/default.nix#L594-L611
  systemd.user.services.xwayland-satellite = {
    Unit = {
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["niri.service"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.xwayland-satellite} :0";
      NotifyAccess = "all";
      StandardOutput = "journal";
      Restart = "on-failure";
    };
  };

  programs.wlogout = {
    enable = true;

    layout = let
      systemd = let
        systemd = lib.getExe' pkgs.systemd;
      in {
        loginctl = systemd "loginctl";
        systemctl = systemd "systemctl";
      };
    in [
      {
        action = "${systemd.loginctl} lock-session";
        keybind = "l";
        label = "lock";
        text = "Lock";
      }

      {
        action = "${systemd.systemctl} hibernate";
        keybind = "h";
        label = "hibernate";
        text = "Hibernate";
      }

      {
        action = "${
          systemd.loginctl
        } terminate-user ${
          config.home.username
        }";

        keybind = "q";
        label = "logout";
        text = "Logout";
      }

      {
        action = "${systemd.systemctl} poweroff";
        keybind = "p";
        label = "shutdown";
        text = "Shutdown";
      }

      {
        action = "${systemd.systemctl} suspend";
        keybind = "s";
        label = "suspend";
        text = "Suspend";
      }

      {
        action = "${systemd.systemctl} reboot";
        keybind = "r";
        label = "reboot";
        text = "Reboot";
      }
    ];
  };
}
