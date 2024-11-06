{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.konsole = let
    inherit (config.theme) scheme;
    schemeData = inputs.basix.schemeData.base16.${scheme};
  in {
    enable = true;
    defaultProfile = "default";
    profiles = {
      default = {
        font = {
          name = "monospace";
          size = 14;
        };
        colorScheme = schemeData.name;
      };
    };

    extraConfig = {
      "MainWindow" = {
        "MenuBar" = "Disabled";
        "ToolBarsMovable" = "Disabled";
      };
      "KonsoleWindow" = {
        "ShowMenuBarByDefault" = "false";
      };
    };

    customColorSchemes = {
      "${schemeData.name}" = pkgs.lib.mkKonsoleColorScheme schemeData;
    };
  };
}
