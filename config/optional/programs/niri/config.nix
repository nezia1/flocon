{
  lib,
  pkgs,
  config,
  inputs',
  ...
}: let
  inherit (builtins) map;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep;
  styleCfg = config.local.style;

  cursorsConfigFile =
    pkgs.writeText "niri-config-cursors"
    # kdl
    ''
      cursor {
          xcursor-theme "${styleCfg.cursors.xcursor.name}"
          xcursor-size ${toString styleCfg.cursors.size}
      }
    '';

  xwaylandConfig =
    pkgs.writeText "niri-config-xwayland"
    # kdl
    ''
      xwayland-satellite {
                 path "${getExe pkgs.xwayland-satellite}"
           }
    '';
in {
  programs.niri = {
    enable = true;
    package = inputs'.niri.packages.default;
  };

  hj.xdg.config.files."niri/config.kdl".source =
    pkgs.writeText "niri-config"
    (concatStringsSep "\n"
      (map (file: ''include "${file}"'') [
        ./top-level.kdl
        ./binds.kdl
        ./inputs.kdl
        ./layout.kdl
        ./window-rules.kdl
        cursorsConfigFile
        xwaylandConfig
      ]));

  hj.packages = [pkgs.xwayland-satellite];
}
