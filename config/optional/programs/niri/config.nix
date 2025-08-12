{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues toString concatStringsSep map;

  inherit (config.local.vars.system) username;
  inherit (config.local.style) cursors;

  toOutputConf = m: let
    toResolutionString = res: rr: "mode \"${toString res.width}x${toString res.height}@${toString rr}\"";
    toPositionString = pos:
      if pos != null
      then "position x=${toString pos.x} y=${toString pos.y}"
      else "position x=0 y=0";
    toScaleString = scale: "scale ${toString scale}";
  in
    concatStringsSep "\n" [
      "output \"${m.name}\" {"
      (toResolutionString m.resolution m.refreshRate)
      (toPositionString m.position)
      (toScaleString m.scale)
      (
        if m.primary
        then "focus-at-startup"
        else null
      )
      "}"
    ];
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  xdg.portal.config.niri = {
    default = "gtk;gnome";
  };

  hj.rum.desktops.niri = {
    enable = true;
    configFile = ./config.kdl;
    extraVariables = {
      DISPLAY = ":0";
    };
    extraConfig =
      ''
        cursor {
          xcursor-theme "${cursors.xcursor.name}"
          xcursor-size ${toString cursors.size}
        }
      ''
      + (concatStringsSep "\n" (map toOutputConf config.local.monitors));
  };

  hjem.users.${username} = {
    packages = attrValues {
      inherit
        (pkgs)
        brillo
        ;
    };
  };
}
