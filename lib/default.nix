let
  # convert rrggbb hex to rgba(r, g, b, a)
  rgba = c: let
    r = toString (hexToDec (builtins.substring 0 2 c));
    g = toString (hexToDec (builtins.substring 2 2 c));
    b = toString (hexToDec (builtins.substring 4 2 c));
  in "rgba(${r}, ${g}, ${b}, .5)";

  # Helper function to convert hex color to decimal RGB values
  hexToDec = lib: v: let
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
  pow = lib: base: exponent: lib.foldl' (acc: _: acc * base) 1 (lib.range 1 exponent);

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
