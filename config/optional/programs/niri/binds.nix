{
  hj.rum.desktops.niri.binds = {
    "Mod+H".action = "focus-column-left";
    "Mod+J".action = "focus-window-or-workspace-down";
    "Mod+K".action = "focus-window-or-workspace-up";
    "Mod+L".action = "focus-column-right";

    "Mod+F".action = "maximize-column";
    "Mod+F11".action = "fullscreen-window";
    "Mod+c".action = "center-column";

    "Mod+Q".action = "close-window";

    "Mod+Space".spawn = ["walker"];
    "Mod+Return".spawn = ["footclient"];
    "Mod+W".spawn = ["librewolf"];

    "Mod+V".action = "toggle-window-floating";
    "Mod+Shift+V".action = "switch-focus-between-floating-and-tiling";

    "Mod+Alt+L".spawn = ["loginctl" "lock-session"];

    Print.action = "screenshot";
    "Shift+Print".action = "screenshot-screen";
    "Ctrl+Print".action = "screenshot-window";

    "Mod+Escape" = {
      parameters.repeat = false;
      action = "toggle-overview";
    };
    XF86AudioRaiseVolume = {
      parameters.allow-when-locked = true;
      spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
    };
    XF86AudioLowerVolume = {
      parameters.allow-when-locked = true;
      spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
    };
    XF86AudioMute = {
      parameters.allow-when-locked = true;
      spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
    };
    XF86MonBrightnessUp = {
      parameters.allow-when-locked = true;
      spawn = ["brillo" "-q" "-u" "300000" "-A" "5"];
    };
    XF86MonBrightnessDown = {
      parameters.allow-when-locked = true;
      spawn = ["brillo" "-q" "-u" "300000" "-U" "5"];
    };
  };
}
