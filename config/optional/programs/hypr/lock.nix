{
  lib,
  myLib,
  inputs',
  config,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) optionalAttrs;

  inherit (myLib.colors) rgba;

  styleCfg = config.local.style;
in {
  security.pam.services.hyprlock.text = "auth include login";
  hj.rum.programs.hyprlock = {
    enable = true;
    package = inputs'.hyprlock.packages.hyprlock;
    settings =
      {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        auth = {
          fingerprint.enabled = true;
        };
      }
      // (optionalAttrs styleCfg.enable
        (let
          rgbaPalette = mapAttrs (_: c: (rgba c 1)) styleCfg.colors.scheme.withHashtag;
        in
          with rgbaPalette; {
            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = {
              rounding = 10;
              outer_color = "${base03}";
              inner_color = "${base00}";
              font_color = "${base05}";
              fail_color = "${base08}";
              check_color = "${base0A}";
            };

            label = [
              {
                monitor = "";
                position = "0, 100";
                text = "$TIME";
                font_size = 40;
                color = "rgb(${base05})";
                halign = "center";
                valign = "center";
              }
              {
                monitor = "";
                text = "$FPRINTPROMPT";
                text_align = "center";
                color = "rgb(${base05})";
                font_size = 24;
                position = "0, -100";
                halign = "center";
                valign = "center";
              }
            ];
          }));
  };
}
