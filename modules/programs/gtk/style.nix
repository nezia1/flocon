palette:
with palette;
/*
css
*/
  ''
    /* Base16 theme
    based on the catpuccin adw-gtk3 theme from claymorwan: https://github.com/claymorwan/adw-catppuccin/blob/e2a3352bb3a1eac7306d397a9945108c878a4c58/mocha/gtk.css */

    /* Adwaita stuff */
    @define-color accent_color ${base0E};
    @define-color accent_bg_color ${base0E};
    @define-color accent_fg_color ${base11};

    @define-color window_bg_color ${base00};
    @define-color window_fg_color ${base05};

    @define-color headerbar_bg_color ${base00};
    @define-color headerbar_fg_color ${base05};

    @define-color popover_bg_color ${base02};
    @define-color popover_fg_color ${base05};

    @define-color dialog_bg_color @popover_bg_color;
    @define-color dialog_fg_color @popover_fg_color;

    @define-color sidebar_bg_color ${base00};
    @define-color sidebar_fg_color ${base05};
    @define-color sidebar_backdrop_color ${base00};
    @define-color sidebar_shade_color RGB(0 0 6 / 25%);
    @define-color sidebar_border_color RGB(0 0 6 / 36%);

    @define-color secondary_sidebar_bg_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_fg_color ${base05};
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_shade_color @sidebar_shade_color;
    @define-color secondary_sidebar_border_color @sidebar_border_color;

    @define-color view_bg_color ${base00};
    @define-color view_fg_color ${base05};

    @define-color card_bg_color ${base02};
    @define-color card_fg_color ${base05};

    @define-color thumbnail_bg_color ${base02};
    @define-color thumbnail_fg_color ${base05};

    @define-color warning_bg_color ${base08};
    @define-color warning_fg_color ${base05};
    @define-color warning_color ${base08};
    @define-color error_bg_color ${base08};
    @define-color error_fg_color ${base05};
    @define-color error_color ${base08};
    @define-color success_bg_color ${base0B};
    @define-color success_fg_color ${base05};
    @define-color success_color ${base0B};
    @define-color destructive_bg_color ${base08};
    @define-color destructive_fg_color ${base11};
    @define-color destructive_color ${base08};

    :root {
      --accent-bg-color: @accent_bg_color;
      --accent-fg-color: @accent_fg_color;

      --destructive-bg-color: @destructive_bg_color;
      --destructive-fg-color: @destructive_fg_color;

      --success-bg-color: @success_bg_color;
      --success-fg-color: @success_fg_color;

      --warning-bg-color: @warning_bg_color;
      --warning-fg-color: @warning_fg_color;

      --error-bg-color: @error_bg_color;
      --error-fg-color: @error_fg_color;

      --window-bg-color: @window_bg_color;
      --window-fg-color: @window_fg_color;

      --view-bg-color: @view_bg_color;
      --view-fg-color: @view_fg_color;

      --headerbar-bg-color: @headerbar_bg_color;
      --headerbar-fg-color: @headerbar_fg_color;
      --headerbar-border-color: @headerbar_border_color;
      --headerbar-backdrop-color: @headerbar_backdrop_color;
      --headerbar-shade-color: @headerbar_shade_color;
      --headerbar-darker-shade-color: @headerbar_darker_shade_color;

      --sidebar-bg-color: @sidebar_bg_color;
      --sidebar-fg-color: @sidebar_fg_color;
      --sidebar-backdrop-color: @sidebar_backdrop_color;
      --sidebar-border-color: @sidebar_border_color;
      --sidebar-shade-color: @sidebar_shade_color;

      --secondary-sidebar-bg-color: @secondary_sidebar_bg_color;
      --secondary-sidebar-fg-color: @secondary_sidebar_fg_color;
      --secondary-sidebar-backdrop-color: @secondary_sidebar_backdrop_color;
      --secondary-sidebar-border-color: @secondary_sidebar_border_color;
      --secondary-sidebar-shade-color: @secondary_sidebar_shade_color;

      --card-bg-color: @card_bg_color;
      --card-fg-color: @card_fg_color;
      --card-shade-color: @card_shade_color;

      --dialog-bg-color: @dialog_bg_color;
      --dialog-fg-color: @dialog_fg_color;

      --popover-bg-color: @popover_bg_color;
      --popover-fg-color: @popover_fg_color;
      --popover-shade-color: @popover_shade_color;

      --thumbnail-bg-color: @thumbnail_bg_color;
      --thumbnail-fg-color: @thumbnail_fg_color;

      --shade-color: @shade_color;
      --scrollbar-outline-color: @scrollbar_outline_color;

      --thumbnail-bg-color: @thumbnail_bg_color;
      --thumbnail-fg-color: @thumbnail_fg_color;
    }
  ''
