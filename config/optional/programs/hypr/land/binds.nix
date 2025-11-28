let
  # thanks https://github.com/fufexan/dotfiles/blob/c0b3c77d95ce1f574a87e7f7ead672ca0d951245/home/programs/wayland/hyprland/binds.nix#L16-L20
  runOnce = program: "pgrep ${program} || app2unit -- ${program}";
  run = program: "app2unit -- ${program}";
in {
  hj.rum.desktops.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      "$mod, Space, exec, dms ipc call spotlight toggle"
      "$mod, Return, exec, ${run "footclient"}"
      "$mod, w, exec, ${run "librewolf"}"
      ", Print, exec, ${runOnce "grimblast"} --notify copysave output"
      "$mod, q, killactive"
      "$mod SHIFT, q, exec, loginctl terminate-user \"\""
      "CTRL, Print, exec, ${runOnce "grimblast"} --notify --freeze copysave area"

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

      "$mod SHIFT, 1, movetoworkspacesilent, 1"
      "$mod SHIFT, 2, movetoworkspacesilent, 2"
      "$mod SHIFT, 3, movetoworkspacesilent, 3"
      "$mod SHIFT, 4, movetoworkspacesilent, 4"
      "$mod SHIFT, 5, movetoworkspacesilent, 5"
      "$mod SHIFT, 6, movetoworkspacesilent, 6"

      "$mod, t, togglefloating"
      ", F11, fullscreen, 0"
      "$mod, f, fullscreen, 1"

      "$mod, e, togglespecialworkspace, file_manager_gui"
      "$mod , c, togglespecialworkspace, calculator_gui"
      "$mod, m, togglespecialworkspace, mixer_gui"

      ", XF86PowerOff, exec, dms ipc call powermenu toggle"
    ];

    bindl = [
      ", switch:on:Lid Switch, exec, systemctl suspend"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 5"
      ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 5"
      ", XF86AudioMute, exec, dms ipc call audio mute"

      ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 10 \"\""
      ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 10 \"\""
    ];
    binde = [
      "$mod Alt, l, exec, loginctl lock-session"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
