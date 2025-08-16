{
  lib,
  inputs',
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep toString;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;

  toMonitorConf = m: let
    toResolutionString = res: rr: "${toString res.width}x${toString res.height}@${toString rr}";
    toPositionString = pos:
      if pos != null
      then "${toString pos.x}x${toString pos.y}"
      else "0x0";
  in
    concatStringsSep ", " [
      m.name
      (toResolutionString m.resolution m.refreshRate)
      (toPositionString m.position)
      (toString m.scale)
    ];

  styleCfg = config.local.style;
in {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
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

  hj = {
    packages = [
      inputs'.hyprwm-contrib.packages.grimblast
    ];

    rum.desktops.hyprland = {
      enable = true;
      plugins = [
        pkgs.hyprlandPlugins.hyprsplit
      ];
      settings =
        {
          xwayland = {
            force_zero_scaling = true;
          };

          exec-once = ["${pkgs.xorg.xrandr}/bin/xrandr --output 'DP-1' --primary"];

          cursor = {
            no_hardware_cursors = 1;
          };

          monitor = map toMonitorConf config.local.monitors;

          workspace = [
            "special:terminal, on-created-empty:ghostty"
            "special:file_manager_gui, on-created-empty:pcmanfm"
            "special:file_manager_tui, on-created-empty:ghostty -e yazi"

            "special:calculator_gui, on-created-empty:qalculate-gtk"
            "special:mixer_gui, on-created-empty:pavucontrol"
          ];

          windowrule =
            [
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

              "float,class:^(xdg-desktop-portal-hyprland)$"
              "float, class:(org.freedesktop.impl.portal.desktop.kde)"
              "size 900 600, class:(org.freedesktop.impl.portal.desktop.kde)"
              "center, class:(org.freedesktop.impl.portal.desktop.kde)"
            ]
            # make polkit-kde-authentication-agent-1 a centered floating window
            ++ (map (rule: rule + ", class:^(org.kde.polkit-kde-authentication-agent-1)$") [
              "float"
              "center 1"
              "stayfocused"
              "size 30% 25%"
              "focusonactivate"
            ]);

          render = {
            expand_undersized_textures = false;
          };

          bezier = "overshot, 0.05, 0.9, 0.1, 1.1";

          animations = {
            enabled = true;
            animation = [
              "windows, 1, 5, overshot"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
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
              num_workspaces = 4;
            };
          };
        }
        // (optionalAttrs styleCfg.enable {
          general = {
            border_size = 4;
            "col.active_border" = "rgb(${styleCfg.colors.scheme.base0E})";
            "col.inactive_border" = "rgb(${styleCfg.colors.scheme.base03})";
          };
          decoration = {
            rounding = 10;
            rounding_power = 3;
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
        });
    };
  };
}
