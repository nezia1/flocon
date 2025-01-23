{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mapAttrs mkIf optionalAttrs removePrefix;
  styleCfg = osConfig.local.style;

  mkGhosttyTheme = palette: let
    colors = mapAttrs (_: value: removePrefix "#" value) palette;
  in {
    palette = [
      "0=#${colors.base00}"
      "1=#${colors.base08}"
      "2=#${colors.base0B}"
      "3=#${colors.base0A}"
      "4=#${colors.base0D}"
      "5=#${colors.base0E}"
      "6=#${colors.base0C}"
      "7=#${colors.base05}"
      "8=#${colors.base02}"
      "9=#${colors.base08}"
      "10=#${colors.base0B}"
      "11=#${colors.base0A}"
      "12=#${colors.base0D}"
      "13=#${colors.base0E}"
      "14=#${colors.base0C}"
      "15=#${colors.base07}"
      "16=#${colors.base09}"
      "17=#${colors.base0F}"
      "18=#${colors.base01}"
      "19=#${colors.base02}"
      "20=#${colors.base04}"
      "21=#${colors.base06}"
    ];
    background = colors.base00;
    foreground = colors.base05;
    cursor-color = colors.base06;
    selection-background = colors.base02;
    selection-foreground = colors.base05;
  };
in {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.ghostty = lib.mkMerge [
      {
        enable = true;
      }
      (optionalAttrs styleCfg.enable {
        settings.theme = "base16";
        themes.base16 = mkIf styleCfg.enable (mkGhosttyTheme styleCfg.scheme.palette);
      })
    ];
  };
}
