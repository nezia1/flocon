_: let
  # thanks https://github.com/fufexan/dotfiles/blob/c0b3c77d95ce1f574a87e7f7ead672ca0d951245/home/programs/wayland/hyprland/binds.nix#L16-L20
  toggle = program: let
    prog = builtins.substring 0 14 program;
  in "pkill ${prog} || uwsm app -- ${program}";
  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
  run = program: "uwsm app -- ${program}";
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, Return, exec, ${run "foot"}"
      "$mod, n, exec, ${run "neovide"}"
      "$mod, w, exec, ${run "firefox"}"
      ", Print, exec, ${runOnce "grimblast"} --notify --cursor copysave output"
      "$mod, q, killactive"
      "$mod SHIFT, q, exec, loginctl terminate-user ''"
      "$mod, Space, exec, walker" # not using uwsm as it already runs as a service
      "CTRL, Print, exec, ${runOnce "grimblast"} --notify --cursor --freeze copysave area"

      "$mod, h, movefocus, l"
      "$mod, j, movefocus, d"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, r"

      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, j, movewindow, d"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, l, movewindow, r"

      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      "$mod SHIFT, 1, movetoworkspacesilent, 1"
      "$mod SHIFT, 2, movetoworkspacesilent, 2"
      "$mod SHIFT, 3, movetoworkspacesilent, 3"
      "$mod SHIFT, 4, movetoworkspacesilent, 4"
      "$mod SHIFT, 5, movetoworkspacesilent, 5"
      "$mod SHIFT, 6, movetoworkspacesilent, 6"
      "$mod SHIFT, 7, movetoworkspacesilent, 7"
      "$mod SHIFT, 8, movetoworkspacesilent, 8"
      "$mod SHIFT, 9, movetoworkspacesilent, 9"
      "$mod SHIFT, 0, movetoworkspacesilent, 10"

      "$mod, t, togglefloating"
      ", F11, fullscreen, 0"
      "$mod, f, fullscreen, 1"

      "$mod, e, togglespecialworkspace, file_manager_tui"
      "$mod SHIFT, e, togglespecialworkspace, file_manager_gui"

      ", XF86PowerOff, exec, ${toggle "wlogout"}"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      ", XF86AudioMedia, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
    ];
    binde = [
      "$mod Alt, l, exec, loginctl lock-session"
    ];
  };
}
