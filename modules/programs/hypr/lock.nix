{
  lib,
  lib',
  flakePkgs,
  config,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;

  inherit (lib') rgba;

  inherit (config.local.vars.system) username;

  styleCfg = config.local.style;
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    hjem.users.${username}.rum.programs.hyprlock = {
      enable = true;
      package = flakePkgs.hyprlock.hyprlock;
      settings =
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

              input-field = {
                outer_color = "${base03}";
                inner_color = "${base00}";
                font_color = "${base05}";
                fail_color = "${base08}";
                check_color = "${base0A}";
              };
            }));
    };
  };
}
