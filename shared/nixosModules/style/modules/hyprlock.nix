{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
  inherit (cfg) scheme;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
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
              color = scheme.palette.base05;

              position = "30, -30";
              halign = "left";
              valign = "top";
            }
            {
              monitor = "";
              text = "$TIME";
              font_size = 90;
              color = scheme.palette.base05;

              position = "-30, 0";
              halign = "right";
              valign = "top";
            }
            {
              monitor = "";
              text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
              font_size = 25;
              color = scheme.palette.base05;

              position = "-30, -150";
              halign = "right";
              valign = "top";
            }
          ];

          image = {
            monitor = "";
            path = "${cfg.avatar}"; # Replace with your avatar path
            size = 100;
            border_color = scheme.palette.base0D;

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

              outer_color = scheme.palette.base0D;
              inner_color = scheme.palette.base02;
              font_color = scheme.palette.base05;

              fade_on_empty = false;
              placeholder_text = "<span foreground=\"#${scheme.palette.base03}\"><i>󰌾 Logged in as </i><span foreground=\"#${scheme.palette.base0D}\">$USER</span></span>";

              hide_input = false;
              check_color = scheme.palette.base0D;
              fail_color = scheme.palette.base08;

              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              capslock_color = scheme.palette.base0E;

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
