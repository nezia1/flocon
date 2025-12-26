{
  lib,
  pkgs,
  config,
  inputs',
  ...
}: let
  inherit (builtins) map;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep optionalString;
  styleCfg = config.local.style;

  toOutputConf = m: let
    toModeString = res: rr: ''mode "${toString res.width}x${toString res.height}@${toString rr}"'';
    toPositionString = pos: "position x=${toString pos.x} y=${toString pos.y}";
    toScaleString = scale: "scale ${toString scale}";
  in
    concatStringsSep "\n" [
      ''output "${m.name}" {''
      (toModeString m.resolution m.refreshRate)
      (optionalString (m.position != null) (toPositionString m.position))
      (toScaleString m.scale)
      (optionalString m.primary "focus-at-startup")
      "}"
    ];

  cursorsConfigFile =
    pkgs.writeText "niri-config-cursors"
    # kdl
    ''
      cursor {
          xcursor-theme "${styleCfg.cursors.xcursor.name}"
          xcursor-size ${toString styleCfg.cursors.size}
      }
    '';

  xwaylandConfigFile =
    pkgs.writeText "niri-config-xwayland"
    # kdl
    ''
      xwayland-satellite {
                 path "${getExe inputs'.xwayland-satellite.packages.default}"
           }
    '';

  outputsConfigFile =
    pkgs.writeText "niri-config-outputs" (concatStringsSep "\n" (map toOutputConf config.local.monitors));
in {
  programs.niri = {
    enable = true;
    package = inputs'.niri.packages.default;
  };

  hj.xdg.config.files."niri/config.kdl".source =
    pkgs.writeText "niri-config"
    (concatStringsSep "\n"
      (map (file: ''include "${file}"'') [
        ./binds.kdl
        ./inputs.kdl
        ./layout.kdl
        ./miscellaneous.kdl
        ./window-rules.kdl

        outputsConfigFile
        cursorsConfigFile
        xwaylandConfigFile
      ]));
}
