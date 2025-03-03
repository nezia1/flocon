{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge optionalAttrs;
  inherit (config.local.systemVars) username;

  styleCfg = config.local.style;

  gnomeControlCenter = pkgs.gnome-control-center.overrideAttrs (old: {
    postInstall =
      old.postInstall
      + ''
        dir=$out/share/applications
        for panel in $dir/*
        do
          [ "$panel" = "$dir/gnome-network-panel.desktop" ] && continue
          [ "$panel" = "$dir/gnome-bluetooth-panel.desktop" ] && continue
          [ "$panel" = "$dir/gnome-wifi-panel.desktop" ] && continue
          [ "$panel" = "$dir/gnome-wwan-panel.desktop" ] && continue
          [ "$panel" = "$dir/gnome-sharing-panel.desktop" ] && continue
          [ "$panel" = "$dir/gnome-wacom-panel.desktop" ] && continue
          rm "$panel"
        done
      '';
  });
in {
  config = mkIf config.local.modules.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
      systemd.setPath.enable = true;
    };

    /*
    needed so that loginctl can cleanup the session correctly with uwsm
    (see https://github.com/Vladimir-csp/uwsm?tab=readme-ov-file#universal-wayland-session-manager)
    */
    services.dbus.implementation = "broker";

    # copied from https://github.com/linyinfeng/dotfiles/blob/91b0363b093303f57885cbae9da7f8a99bbb4432/nixos/profiles/graphical/niri/default.nix#L17-L29
    security.pam.services.hyprlock.text = mkIf config.services.fprintd.enable ''
      account required pam_unix.so

      # check passwork before fprintd
      auth sufficient pam_unix.so try_first_pass likeauth
      auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth required pam_deny.so

      password sufficient pam_unix.so nullok yescrypt

      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';

    hjem.users.${username} = {
      packages = [
        inputs.hyprwm-contrib.packages.${pkgs.system}.grimblast
        gnomeControlCenter
      ];

      rum.programs.hyprland = {
        enable = true;
        plugins = [
          inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
        ];
        settings =
          {
            xwayland = {
              force_zero_scaling = true;
            };

            env = [
            ];

            cursor = {
              no_hardware_cursors = 1;
            };

            monitor = [
              "eDP-1, preferred, auto, 1.33"
              "Unknown-1,disabled"

              "HDMI-A-1, preferred, 0x0, 1"
              "DP-1, preferred, 1920x0, 1"
            ];
            workspace = [
              "special:terminal, on-created-empty:ghostty"
              "special:file_manager_gui, on-created-empty:pcmanfm"
              "special:file_manager_tui, on-created-empty:ghostty -e yazi"

              "special:calculator_gui, on-created-empty:qalculate-gtk"
              "special:mixer_gui, on-created-empty:pavucontrol"

              "f[1], gapsout:0, gapsin:0"
              "w[tv1], gapsout:0, gapsin:0"
            ];

            windowrulev2 = [
              # fixes fullscreen windows (mostly games)
              "stayfocused, initialtitle:^()$, initialclass:^(steam)$"
              "minsize 1 1, initialtitle:^()$, initialclass:^(steam)$"
              "maximize, initialtitle:^(\S+)$, initialclass:^(steamwebhelper)$"

              "immediate, initialclass:^(steam_app_)(.*)$"
              "fullscreen, initialclass:^(steam_app_)(.*)$"

              # inhibit idle on fullscreen apps (avoids going idle on games when playing with gamepad)
              "idleinhibit always, fullscreen:1"

              "float, title:^(Picture-in-Picture)$"
              "pin, title:^(Picture-in-Picture)$"

              # smart gaps
              "bordersize 0, floating:0, onworkspace:w[tv1]"
              "rounding 0, floating:0, onworkspace:w[tv1]"
              "bordersize 0, floating:0, onworkspace:f[1]"
              "rounding 0, floating:0, onworkspace:f[1]"
            ];

            render = {
              explicit_sync = 1;
              explicit_sync_kms = 1;
              expand_undersized_textures = false;
            };

            bezier = "overshot, 0.05, 0.9, 0.1, 1.1";

            animations = {
              enabled = true;
              animation = [
                "windows, 1, 5, overshot"
                "windowsOut, 1, 5, default, popin 80%"
                "windowsMove, 1, 5, default, popin 80%"
                "fade, 1, 5, default"
                "border, 1, 5, default"
                "borderangle, 0, 8, default"
                "workspaces, 0"
                "specialWorkspace, 0"
              ];
            };

            input = {
              kb_options = "compose:ralt";
              touchpad = {
                natural_scroll = true;
                scroll_factor = 0.8;
                tap-to-click = true;
                clickfinger_behavior = true;
              };
            };

            gestures = {
              workspace_swipe = true;
              workspace_swipe_direction_lock = false;
              workspace_swipe_cancel_ratio = 0.15;
            };

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              middle_click_paste = false;
            };
            plugin = {
              hyprsplit = {
                num_workspaces = 6;
              };
            };
          }
          // optionalAttrs styleCfg.enable {
            general = {
              border_size = 4;
              "col.active_border" = "rgb(${lib.removePrefix "#" styleCfg.scheme.palette.base0E})";
            };
            decoration = {
              rounding = 16;

              blur = {
                enabled = true;
                size = 5;
                passes = 3;
                ignore_opacity = true;
                new_optimizations = 1;
                xray = true;
                contrast = 0.7;
                brightness = 0.8;
                vibrancy = 0.2;
                special = true;
              };

              shadow = {
                enabled = true;
                range = 32;
                render_power = 3;
                ignore_window = true;
                scale = 1;
                color = "rgba(00000048)";
                color_inactive = "rgba(00000028)";
              };
            };
          }
          // import ./binds.nix lib;
      };

      environment.sessionVariables = mkMerge [
        {
          GDK_SCALE = 1;
        }
        (mkIf styleCfg.enable {
          HYPRCURSOR_THEME = styleCfg.cursorTheme.name;
          HYPRCURSOR_SIZE = styleCfg.cursorTheme.size;
          XCURSOR_SIZE = styleCfg.cursorTheme.size;
        })
        (mkIf config.local.modules.nvidia.enable {
          LIBVA_DRIVER_NAME = "nvidia";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          XDG_SESSION_TYPE = "wayland";
          GBM_BACKEND = "nvidia-drm";
        })
      ];
    };
  };
}
