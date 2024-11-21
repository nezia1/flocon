{lib, ...}: let
  # convert rrggbb hex to rgba(r, g, b, a)
  rgba = c: let
    r = toString (hexToDec (builtins.substring 0 2 c));
    g = toString (hexToDec (builtins.substring 2 2 c));
    b = toString (hexToDec (builtins.substring 4 2 c));
  in "rgba(${r}, ${g}, ${b}, .5)";

  # Helper function to convert hex color to decimal RGB values
  hexToDec = v: let
    hexToInt = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
      "A" = 10;
      "B" = 11;
      "C" = 12;
      "D" = 13;
      "E" = 14;
      "F" = 15;
    };
    chars = lib.strings.stringToCharacters v;
  in
    lib.foldl' (a: v: a + v) 0
    (lib.imap (k: v: hexToInt."${v}" * (pow 16 (builtins.length chars - k - 1))) chars);

  # Power function for exponentiation
  pow = base: exponent: lib.foldl' (acc: _: acc * base) 1 (lib.range 1 exponent);

  # Converts hex color to KDE color format
  colorToKde = name: hexColor: let
    r = hexToDec (builtins.substring 0 2 hexColor);
    g = hexToDec (builtins.substring 2 2 hexColor);
    b = hexToDec (builtins.substring 4 2 hexColor);
  in "[${name}]\nColor=${toString r},${toString g},${toString b}\n";

  # Mapping base16 colors to KDE color scheme sections
  schemeToKonsole = scheme: let
    inherit (scheme) palette;

    colorMap = {
      base00 = ["Background" "BackgroundFaint" "BackgroundIntense"];
      base01 = ["Color0"];
      base02 = ["Color0Intense"];
      base04 = ["Color4"];
      base05 = ["Foreground" "ForegroundFaint" "ForegroundIntense"];
      base06 = ["Color7"];
      base07 = ["Color7Intense"];
      base08 = ["Color1" "Color1Intense"];
      base09 = ["Color1Intense"];
      base0A = ["Color3" "Color3Intense"];
      base0B = ["Color2" "Color2Intense"];
      base0C = ["Color6" "Color6Intense"];
      base0D = ["Color4" "Color4Intense"];
      base0E = ["Color5" "Color5Intense"];
    };

    colorSections = lib.concatStringsSep "\n" (lib.attrsets.mapAttrsToList
      (name: value:
        lib.concatMapStrings (slot: colorToKde slot value) (colorMap.${name} or []))
      palette);
  in
    lib.concatStringsSep "\n" [
      "[General]"
      "Description=${scheme.name}"
      "Opacity=1"
      "Wallpaper="
      colorSections
    ];

  # Create a KDE konsole color scheme from base16 colors
  mkKonsoleColorScheme = pkgs: scheme:
    pkgs.writeText "${scheme.name}.colorscheme" (schemeToKonsole scheme);
in {
  inherit mkKonsoleColorScheme rgba;
}
