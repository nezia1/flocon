{pkgs, ...}: let
  version = "v17.4";
in
  pkgs.stdenv.mkDerivation {
    inherit version;
    name = "apple-color-emoji";
    src = pkgs.fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/${version}/AppleColorEmoji.ttf";
      sha256 = "sha256-SG3JQLybhY/fMX+XqmB/BKhQSBB0N1VRqa+H6laVUPE=";
    };
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/fonts/truetype/apple-color-emoji
      cp $src $out/share/fonts/truetype/apple-color-emoji/AppleColorEmoji.ttf
    '';
  }
