{
  lib,
  lib',
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;

  inherit (lib') rgba;
  inherit (lib'.generators) toHyprConf;

  inherit (inputs.hyprlock.packages.${pkgs.system}) hyprlock;
  inherit (config.local.systemVars) username;

  styleCfg = config.local.style;
in {
  config = mkIf (config.local.homeVars.desktop == "Hyprland") {
    hjem.users.${username} = {
      packages = [hyprlock];
      files = {
        ".config/hypr/hyprlock.conf".text = toHyprConf {
          attrs =
            {
              general = {
                disable_loading_bar = true;
                hide_cursor = true;
              };
            }
            // (optionalAttrs styleCfg.enable
              (let
                rgbaPalette = mapAttrs (_: c: (rgba c 1)) styleCfg.colors.scheme.palette;
              in
                with rgbaPalette; {
                  background = [
                    {
                      path = "screenshot";
                      blur_passes = 3;
                      blur_size = 8;
                    }
                  ];

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
                    path = "${styleCfg.avatar}"; # Replace with your avatar path
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
                      placeholder_text = "<span foreground=\"#${styleCfg.colors.scheme.palette.base05}\"><i>󰌾 Logged in as </i><span foreground=\"#${styleCfg.colors.scheme.palette.base0D}\">$USER</span></span>";

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
                }));
        };
      };
    };
  };
}
