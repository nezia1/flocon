{
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}: let
  inherit (builtins) toString;
  styleCfg = osConfig.local.style;
in {
  imports = [./binds.nix];

  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    home.packages = [
      inputs.hyprwm-contrib.packages.${pkgs.system}.grimblast
      # disable unused panels - https://github.com/maydayv7/dotfiles/blob/4de45008a6915753834aa7e1cbafbacfff8b7adc/modules/gui/desktop/hyprland/apps/utilities.nix#L42-L57
      (pkgs.gnome-control-center.overrideAttrs (old: {
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
      }))
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      systemd.enable = false;

      settings = lib.mkMerge [
        {
          xwayland = {
            force_zero_scaling = true;
          };

          env = [
            "GDK_SCALE,1"
          ];

          cursor = {
            no_hardware_cursors = 1;
          };

          monitor = [
            "eDP-1, preferred, auto, 1.33"
          ];
          workspace = [
            "special:terminal, on-created-empty:foot"
            "special:mixer_gui, on-created-empty:pavucontrol"
            "special:file_manager_gui, on-created-empty:nautilus"
            "special:file_manager_tui, on-created-empty:foot -- yazi"
          ];

          windowrulev2 = [
            # fixes fullscreen windows (mostly games)
            "stayfocused, initialtitle:^()$, initialclass:^(steam)$"
            "minsize 1 1, initialtitle:^()$, initialclass:^(steam)$"
            "maximize, initialtitle:^(\S+)$, initialclass:^(steamwebhelper)$"

            "immediate, initialclass:^(steam_app_)(.*)$"
            "fullscreen, initialclass:^(steam_app_)(.*)$"

            # inhibit idle on every fullscreen app except games
            "idleinhibit always, fullscreen:1,!initialclass:^(steam_app_)(.*)$"
          ];

          render = {
            explicit_sync = 1;
            explicit_sync_kms = 1;
            expand_undersized_textures = false;
          };

          animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.1";
            animation = [
              "windows, 1, 5, myBezier"
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
        }

        (lib.mkIf styleCfg.enable {
          env = [
            "HYPRCURSOR_THEME,${styleCfg.cursorTheme.name}"
            "HYPRCURSOR_SIZE,${toString styleCfg.cursorTheme.size}"
            "XCURSOR_SIZE,${toString styleCfg.cursorTheme.size}"
          ];
          general = {
            border_size = 4;
            "col.active_border" = "rgb(${lib.removePrefix "#" styleCfg.scheme.palette.base0E})";
          };
          decoration = {
            rounding = 10;
            blur.enabled = true;
          };
        })
      ];
    };
  };
}
