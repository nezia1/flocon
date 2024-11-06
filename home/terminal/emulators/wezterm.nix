{
  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
        local w = require('wezterm')

        local function is_vim(pane)
        return pane:get_user_vars().IS_NVIM == 'true'
        end

        local direction_keys = {
          h = 'Left',
          j = 'Down',
          k = 'Up',
          l = 'Right',
        }

      local function split_nav(resize_or_move, key)
        return {
          key = key,
          mods = resize_or_move == 'resize' and 'META' or 'CTRL',
          action = w.action_callback(function(win, pane)
              if is_vim(pane) then
              win:perform_action({
                SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
                }, pane)
              else
              if resize_or_move == 'resize' then
              win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
              else
              win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
              end
              end
              end),
        }
      end

        return {
          enable_wayland = false,
                         front_end = "WebGpu",
                         hide_tab_bar_if_only_one_tab = true,
                         show_new_tab_button_in_tab_bar = false,
                         harfbuzz_features = { "ss01", "ss03" },

                         leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 },

                         keys = {
                           {
                             mods = "LEADER",
                             key = "-",
                             action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
                           },
                           {
                             mods = "LEADER",
                             key = "=",
                             action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
                           },
                           split_nav('move', 'h'),
                           split_nav('move', 'j'),
                           split_nav('move', 'k'),
                           split_nav('move', 'l'),
                           split_nav('resize', 'h'),
                           split_nav('resize', 'j'),
                           split_nav('resize', 'k'),
                           split_nav('resize', 'l'),
                         },
        }
    '';
  };
}
