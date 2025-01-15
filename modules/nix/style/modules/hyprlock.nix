{
  lib,
  lib',
  config,
  ...
}: let
  cfg = config.local.style;

  # hyprlock takes colors such as rgb[a](r, g, b [, a])
  rgbaPalette = builtins.mapAttrs (_: c: (lib'.rgba c 1)) cfg.scheme.palette;
in {
  config.home-manager.sharedModules = with rgbaPalette;
    lib.mkIf cfg.enable [
      {
        programs.hyprlock = {
          settings = {
            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            general = {
              disable_loading_bar = true;
              hide_cursor = true;
            };

            label = [
              {
                monitor = "";
                text = "Layout: $LAYOUT";
                font_size = 25;
                color = base05;

                position = "30, -30";
                halign = "left";
                valign = "top";
              }
              {
                monitor = "";
                text = "$TIME";
                font_size = 90;
                color = base05;

                position = "-30, 0";
                halign = "right";
                valign = "top";
              }
              {
                monitor = "";
                text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
                font_size = 25;
                color = base05;

                position = "-30, -150";
                halign = "right";
                valign = "top";
              }
            ];

            image = {
              monitor = "";
              path = "${cfg.avatar}"; # Replace with your avatar path
              size = 100;
              border_color = base0D;

              position = "0, 75";
              halign = "center";
              valign = "center";
            };

            input-field = [
              {
                monitor = "";

                size = "300, 60";
                outline_thickness = 4;
                dots_size = 0.2;
                dots_spacing = 0.2;
                dots_center = true;

                outer_color = base0D;
                inner_color = base02;
                font_color = base05;

                fade_on_empty = false;

                # the span elements still use #RRGGBB, so we use scheme directly
                placeholder_text = "<span foreground=\"#${cfg.scheme.palette.base05}\"><i>󰌾 Logged in as </i><span foreground=\"#${cfg.scheme.palette.base0D}\">$USER</span></span>";

                hide_input = false;
                check_color = base0D;
                fail_color = base08;

                fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
                capslock_color = base0E;

                position = "0, -47";
                halign = "center";
                valign = "center";
              }
            ];
          };
        };
      }
    ];
}
