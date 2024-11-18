{
  config,
  pkgs,
  lib,
  ...
}: let
  appLauncher = "fuzzel";
  terminal = "foot";
  browser = "firefox";
  prefix = "Alt";
  guiFileManager = "nautilus";
  cliFileManager = "yazi";
in {
  programs.niri.settings.binds = {
    "${prefix}+D".action.spawn = appLauncher;
    "${prefix}+Return".action.spawn = terminal;
    "${prefix}+W".action.spawn = browser;
    "${prefix}+E".action.spawn = guiFileManager;
    "${prefix}+Shift+E".action.spawn = [terminal "-e" cliFileManager];

    "${prefix}+Shift+Slash".action = config.lib.niri.actions.show-hotkey-overlay;
    "${prefix}+Q".action = config.lib.niri.actions.close-window;
    "${prefix}+Shift+Q".action.quit.skip-confirmation = true;
    "${prefix}+F".action = config.lib.niri.actions.maximize-column;
    "${prefix}+Shift+F".action = config.lib.niri.actions.fullscreen-window;
    "${prefix}+C".action = config.lib.niri.actions.center-column;

    # Focus
    "${prefix}+Left".action = config.lib.niri.actions.focus-column-left;
    "${prefix}+Down".action = config.lib.niri.actions.focus-window-down;
    "${prefix}+Up".action = config.lib.niri.actions.focus-window-up;
    "${prefix}+Right".action = config.lib.niri.actions.focus-column-right;
    "${prefix}+H".action = config.lib.niri.actions.focus-column-left;
    "${prefix}+J".action = config.lib.niri.actions.focus-window-down;
    "${prefix}+K".action = config.lib.niri.actions.focus-window-up;
    "${prefix}+L".action = config.lib.niri.actions.focus-column-right;
    "${prefix}+Home".action = config.lib.niri.actions.focus-column-first;
    "${prefix}+End".action = config.lib.niri.actions.focus-column-last;

    # Move
    "${prefix}+Ctrl+Left".action = config.lib.niri.actions.move-column-left;
    "${prefix}+Ctrl+Down".action = config.lib.niri.actions.move-window-down;
    "${prefix}+Ctrl+Up".action = config.lib.niri.actions.move-window-up;
    "${prefix}+Ctrl+Right".action = config.lib.niri.actions.move-column-right;
    "${prefix}+Ctrl+H".action = config.lib.niri.actions.move-column-left;
    "${prefix}+Ctrl+J".action = config.lib.niri.actions.move-window-down;
    "${prefix}+Ctrl+K".action = config.lib.niri.actions.move-window-up;
    "${prefix}+Ctrl+L".action = config.lib.niri.actions.move-column-right;
    "${prefix}+Ctrl+Home".action = config.lib.niri.actions.move-column-to-first;
    "${prefix}+Ctrl+End".action = config.lib.niri.actions.move-column-to-last;

    # Monitor focus
    "${prefix}+Shift+Left".action = config.lib.niri.actions.focus-monitor-left;
    "${prefix}+Shift+Down".action = config.lib.niri.actions.focus-monitor-down;
    "${prefix}+Shift+Up".action = config.lib.niri.actions.focus-monitor-up;
    "${prefix}+Shift+Right".action = config.lib.niri.actions.focus-monitor-right;
    "${prefix}+Shift+H".action = config.lib.niri.actions.focus-monitor-left;
    "${prefix}+Shift+J".action = config.lib.niri.actions.focus-monitor-down;
    "${prefix}+Shift+K".action = config.lib.niri.actions.focus-monitor-up;
    "${prefix}+Shift+L".action = config.lib.niri.actions.focus-monitor-right;

    # Move to monitor
    "${prefix}+Shift+Ctrl+Left".action = config.lib.niri.actions.move-column-to-monitor-left;
    "${prefix}+Shift+Ctrl+Down".action = config.lib.niri.actions.move-column-to-monitor-down;
    "${prefix}+Shift+Ctrl+Up".action = config.lib.niri.actions.move-column-to-monitor-up;
    "${prefix}+Shift+Ctrl+Right".action = config.lib.niri.actions.move-column-to-monitor-right;
    "${prefix}+Shift+Ctrl+H".action = config.lib.niri.actions.move-column-to-monitor-left;
    "${prefix}+Shift+Ctrl+J".action = config.lib.niri.actions.move-column-to-monitor-down;
    "${prefix}+Shift+Ctrl+K".action = config.lib.niri.actions.move-column-to-monitor-up;
    "${prefix}+Shift+Ctrl+L".action = config.lib.niri.actions.move-column-to-monitor-right;

    # Workspace navigation
    "${prefix}+Page_Down".action = config.lib.niri.actions.focus-workspace-down;
    "${prefix}+Page_Up".action = config.lib.niri.actions.focus-workspace-up;
    "${prefix}+U".action = config.lib.niri.actions.focus-workspace-down;
    "${prefix}+I".action = config.lib.niri.actions.focus-workspace-up;
    "${prefix}+Ctrl+Page_Down".action = config.lib.niri.actions.move-column-to-workspace-down;
    "${prefix}+Ctrl+Page_Up".action = config.lib.niri.actions.move-column-to-workspace-up;
    "${prefix}+Ctrl+U".action = config.lib.niri.actions.move-column-to-workspace-down;
    "${prefix}+Ctrl+I".action = config.lib.niri.actions.move-column-to-workspace-up;
    "${prefix}+Shift+Page_Down".action = config.lib.niri.actions.move-workspace-down;
    "${prefix}+Shift+Page_Up".action = config.lib.niri.actions.move-workspace-up;
    "${prefix}+Shift+U".action = config.lib.niri.actions.move-workspace-down;

    # Workspace focus
    "${prefix}+1".action.focus-workspace = 1;
    "${prefix}+2".action.focus-workspace = 2;
    "${prefix}+3".action.focus-workspace = 3;
    "${prefix}+4".action.focus-workspace = 4;
    "${prefix}+5".action.focus-workspace = 5;
    "${prefix}+6".action.focus-workspace = 6;
    "${prefix}+7".action.focus-workspace = 7;
    "${prefix}+8".action.focus-workspace = 8;
    "${prefix}+9".action.focus-workspace = 9;

    # Move to workspace
    "${prefix}+Ctrl+1".action.move-column-to-workspace = 1;
    "${prefix}+Ctrl+2".action.move-column-to-workspace = 2;
    "${prefix}+Ctrl+3".action.move-column-to-workspace = 3;
    "${prefix}+Ctrl+4".action.move-column-to-workspace = 4;
    "${prefix}+Ctrl+5".action.move-column-to-workspace = 5;
    "${prefix}+Ctrl+6".action.move-column-to-workspace = 6;
    "${prefix}+Ctrl+7".action.move-column-to-workspace = 7;
    "${prefix}+Ctrl+8".action.move-column-to-workspace = 8;
    "${prefix}+Ctrl+9".action.move-column-to-workspace = 9;
    "${prefix}+Shift+I".action = config.lib.niri.actions.move-workspace-up;

    # Window management
    "${prefix}+Comma".action = config.lib.niri.actions.consume-window-into-column;
    "${prefix}+Period".action = config.lib.niri.actions.expel-window-from-column;
    "${prefix}+BracketLeft".action = config.lib.niri.actions.consume-or-expel-window-left;
    "${prefix}+BracketRight".action = config.lib.niri.actions.consume-or-expel-window-right;

    # Column management
    "${prefix}+R".action = config.lib.niri.actions.switch-preset-column-width;
    "${prefix}+Shift+R".action = config.lib.niri.actions.switch-preset-window-height;
    "${prefix}+Ctrl+R".action = config.lib.niri.actions.reset-window-height;
    "${prefix}+Minus".action = config.lib.niri.actions.set-column-width "-10%";
    "${prefix}+Equal".action = config.lib.niri.actions.set-column-width "+10%";
    "${prefix}+Shift+Minus".action = config.lib.niri.actions.set-window-height "-10%";
    "${prefix}+Shift+Equal".action = config.lib.niri.actions.set-window-height "+10%";

    # Screenshots
    "Print".action = config.lib.niri.actions.screenshot-screen;
    "Ctrl+Print".action = config.lib.niri.actions.screenshot;

    # System
    "${prefix}+Mod+L".action.spawn = [
      "${lib.getExe' pkgs.systemd "loginctl"}"
      "lock-session"
    ];

    # Media keys
    "XF86AudioRaiseVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      allow-when-locked = true;
    };
    "XF86AudioPlay" = {
      action.spawn = ["playerctl" "play-pause"];
    };
    "XF86MonBrightnessUp" = {
      action.spawn = ["brillo" "-q" "-u 300000" "-A 5"];
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action.spawn = ["brillo" "-q" "-u 300000" "-U 5"];
      allow-when-locked = true;
    };
    # set on media key since framework laptops have a gear as the button label
    "XF86AudioMedia" = {
      action.spawn = ["sh" "-c" "env XDG_CURRENT_DESKTOP=gnome gnome-control-center"];
    };

    "XF86PowerOff".action.spawn = "wlogout";
  };
}
