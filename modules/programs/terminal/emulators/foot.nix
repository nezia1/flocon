{
  lib,
  pkgs,
  config,
  npins,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  inherit (config.local.vars.system) username;

  styleCfg = config.local.style;

  # because someone thought this was a great idea: https://github.com/tinted-theming/schemes/commit/61058a8d2e2bd4482b53d57a68feb56cdb991f0b
  palette = mapAttrs (_: color: lib.removePrefix "#" color) styleCfg.colors.scheme.palette;
  mkColors = palette: {
    alpha = ".8";
    foreground = palette.base05;
    background = palette.base00;
    regular0 = palette.base00;
    regular1 = palette.base08;
    regular2 = palette.base0B;
    regular3 = palette.base0A;
    regular4 = palette.base0D;
    regular5 = palette.base0E;
    regular6 = palette.base0C;
    regular7 = palette.base05;
    bright0 = palette.base02;
    bright1 = palette.base08;
    bright2 = palette.base0B;
    bright3 = palette.base0A;
    bright4 = palette.base0D;
    bright5 = palette.base0E;
    bright6 = palette.base0C;
    bright7 = palette.base07;
    "16" = palette.base09;
    "17" = palette.base0F;
    "18" = palette.base01;
    "19" = palette.base02;
    "20" = palette.base04;
    "21" = palette.base06;
  };

  foot = pkgs.foot.overrideAttrs {
    pname = "foot";
    version = "0-unstable-${npins.foot.revision}";
    src = npins.foot;
  };
in {
  config = mkIf (config.local.vars.home.desktop != "none") {
    hjem.users.${username} = {
      rum.programs.foot = {
        enable = true;
        package = foot;
        settings = {
          main = {
            term = "xterm-256color";
            font = concatStringsSep "," ["monospace:size=14"];
            bold-text-in-bright = "no";
            alpha-mode = "matching";
            transparent-fullscreen = "yes";
          };
          cursor = {
            style = "beam";
            blink = true;
          };

          colors = optionalAttrs styleCfg.enable (mkColors palette);
        };
      };

      systemd.services.foot-server = {
        name = "foot-server";
        description = "foot terminal service";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        path = lib.mkForce [];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${foot}/bin/foot --server";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };
      };
    };
  };
}
