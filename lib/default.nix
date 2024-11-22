let
  # convert rrggbb hex to rgba(r, g, b, a)
  rgba = lib: color: opacity: let
    r = toString (hexToDec lib (builtins.substring 0 2 color));
    g = toString (hexToDec lib (builtins.substring 2 2 color));
    b = toString (hexToDec lib (builtins.substring 4 2 color));
  in "rgba(${r}, ${g}, ${b}, ${opacity})";

  hexToDec = lib: v: let
    # Map of hex characters to their decimal values
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
    # Remove any leading `#` from the input
    cleanHex =
      if lib.strings.substring 0 1 v == "#"
      then lib.strings.substring 1 (builtins.stringLength v - 1) v
      else v;
    # Convert the cleaned string into characters
    chars = lib.strings.stringToCharacters cleanHex;
  in
    # Fold over the characters to calculate the decimal value
    builtins.foldl' (acc: char: acc * 16 + hexToInt."${char}") 0 chars;

  blurImage = pkgs: path:
    pkgs.runCommand "${builtins.baseNameOf path}-blurred" {
      buildInputs = [pkgs.imagemagick];
    }
    ''
      magick ${path} -gaussian-blur 0x12 "$out"
    '';
in {
  inherit blurImage rgba;
}
