{
  inputs,
  pkgs,
  ...
}: {
  imports = [./binds.nix];
  home.packages = [
    inputs.hyprwm-contrib.packages.${pkgs.system}.grimblast
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };

    settings = {
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
          tap-to-click = false;
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
    };
  };
}
