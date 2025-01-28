{
  lib,
  lib',
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkIf optionalAttrs optionalString;
  inherit (lib'.generators) toHyprConf;
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
    environment.systemPackages = [
      inputs.hyprland-qtutils.packages.${pkgs.system}.default
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
      systemd.setPath.enable = true;
    };

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
      files = {
        ".config/hypr/hyprland.conf".text = toHyprConf {
          attrs =
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
            }
            // optionalAttrs styleCfg.enable {
              general = {
                border_size = 4;
                "col.active_border" = "rgb(${lib.removePrefix "#" styleCfg.scheme.palette.base0E})";
              };
              decoration = {
                rounding = 10;
                blur.enabled = true;
              };
            }
            // import ./binds.nix lib;
        };
        ".config/environment.d/${config.local.homeVars.userEnvFile}.conf".text =
          ''
            GDK_SCALE="1"
          ''
          + optionalString styleCfg.enable ''

            HYPRCURSOR_THEME="${styleCfg.cursorTheme.name}"
            HYPRCURSOR_SIZE="${toString styleCfg.cursorTheme.size}"
            XCURSOR_SIZE="${toString styleCfg.cursorTheme.size}"

          ''
          + optionalString config.local.modules.nvidia.enable ''
            LIBVA_DRIVER_NAME="nvidia"
            __GLX_VENDOR_LIBRARY_NAME="nvidia"
            XDG_SESSION_TYPE="wayland"
            GBM_BACKEND="nvidia-drm"
          '';
      };
    };
  };
}
