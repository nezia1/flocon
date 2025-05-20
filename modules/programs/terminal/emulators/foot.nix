{
  lib,
  pkgs,
  config,
  pins,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;

  styleCfg = config.local.style;

  foot = pkgs.foot.overrideAttrs {
    pname = "foot";
    version = "0-unstable-${pins.foot.revision}";
    src = pins.foot;
  };

  inherit (config.programs) matugen;
in {
  config = mkIf (config.local.vars.home.desktop != null) {
    programs.matugen.templates.foot = mkIf styleCfg.enable {
      input_path = "${pins.matugen-themes}/templates/foot.ini";
      output_path = "~/foot-theme.ini";
    };

    hj = {
      rum.programs.foot = {
        enable = true;
        package = foot;
        settings = {
          main = {
            term = "xterm-256color";
            font = concatStringsSep "," ["monospace:size=14"];
            bold-text-in-bright = "no";
            horizontal-letter-offset = 0;
            vertical-letter-offset = 0;
            pad = "4x4 center";
            include = mkIf styleCfg.enable "${matugen.theme.files}/${builtins.baseNameOf matugen.templates.foot.output_path}";
          };
          cursor = {
            style = "beam";
            blink = true;
          };

          desktop-notifications = {
            command = "${getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
          };

          url = {
            launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
          };
        };
      };
    };

    hm.systemd.user.services.foot-server = {
      Unit = {
        Name = "foot-server";
        Description = "foot terminal service";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        # Path = lib.mkForce [];
      };

      Service = {
        Type = "simple";
        ExecStart = "${foot}/bin/foot --server";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
