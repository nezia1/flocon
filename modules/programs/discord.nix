{
  lib,
  pkgs,
  config,
  npins,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
  styleCfg = config.local.style;
  discord = pkgs.vesktop;
in {
  config = mkIf (config.local.homeVars.desktop != "none") {
    hjem.users.${username} = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
      files.".config/vesktop/themes/base16.css".text = with styleCfg.colors.scheme.palette;
        mkIf styleCfg.enable
        (
          (builtins.readFile "${npins.base16-discord.outPath}/base16.css")
          +
          /*
          css
          */
          ''
            :root {
                --base00: ${base00};
                --base01: ${base01};
                --base02: ${base02};
                --base03: ${base03};
                --base04: ${base04};
                --base05: ${base05};
                --base06: ${base06};
                --base07: ${base07};
                --base08: ${base08};
                --base09: ${base09};
                --base0A: ${base0A};
                --base0B: ${base0B};
                --base0C: ${base0C};
                --base0D: ${base0D};
                --base0E: ${base0E};
                --base0F: ${base0F};
            }
          ''
        );
    };
  };
}
