{lib, ...}: let
  inherit (builtins) substring;

  # thanks https://github.com/fufexan/dotfiles/blob/c0b3c77d95ce1f574a87e7f7ead672ca0d951245/home/programs/wayland/hyprland/binds.nix#L16-L20
  toggle = program: app2unit: let
    prog = substring 0 14 program;
  in "pkill ${prog} || ${lib.optionalString app2unit "app2unit -- "} ${program}";
  runOnce = program: "pgrep ${program} || app2unit -- ${program}";
  run = program: "app2unit -- ${program}";
in {
  hj.rum.desktops.hyprland.settings = {
    "$mod" = "SUPER";
    bindr = [
      "$mod, SUPER_L, exec, ${toggle "walker" false}"
    ];
    bind = [
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

      "$mod, 1, split:workspace, 1"
      "$mod, 2, split:workspace, 2"
      "$mod, 3, split:workspace, 3"
      "$mod, 4, split:workspace, 4"
      "$mod, 5, split:workspace, 5"
      "$mod, 6, split:workspace, 6"

      "$mod SHIFT, 1, split:movetoworkspacesilent, 1"
      "$mod SHIFT, 2, split:movetoworkspacesilent, 2"
      "$mod SHIFT, 3, split:movetoworkspacesilent, 3"
      "$mod SHIFT, 4, split:movetoworkspacesilent, 4"
      "$mod SHIFT, 5, split:movetoworkspacesilent, 5"
      "$mod SHIFT, 6, split:movetoworkspacesilent, 6"

      "$mod, G, split:grabroguewindows"

      "$mod, t, togglefloating"
      ", F11, fullscreen, 0"
      "$mod, f, fullscreen, 1"

      "$mod, e, togglespecialworkspace, file_manager_gui"
      "$mod SHIFT, e, togglespecialworkspace, file_manager_tui"
      "$mod , c, togglespecialworkspace, calculator_gui"
      "$mod, m, togglespecialworkspace, mixer_gui"

      ", XF86PowerOff, exec, ${toggle "wlogout" true}"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
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
