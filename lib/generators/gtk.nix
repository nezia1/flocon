{lib, ...}: let
  # toGtk3Ini , formatGtk2Option , and finalGtk2Text are all taken from https://github.com/nix-community/home-manager, with some minor modifications to their function.
  # All of the gtk generator functions are available under the MIT License.
  inherit (builtins) isBool;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.generators) toINI;
  inherit (lib.strings) concatMapStrings escape isString;
  inherit (lib.trivial) boolToString;

  formatGtk2Option = n: v: let
    v' =
      if isBool v
      then boolToString v
      else if isString v
      then ''"${v}"''
      else toString v;
  in "${escape ["="] n} = ${v'}";
in {
  toGtk3Ini = toINI {
    mkKeyValue = key: value: let
      value' =
        if isBool value
        then boolToString value
        else toString value;
    in "${escape ["="] key}=${value'}";
  };
  formatGtk2Option = n: v: let
    v' =
      if isBool v
      then boolToString v
      else if isString v
      then ''"${v}"''
      else toString v;
  in "${escape ["="] n} = ${v'}";
  finalGtk2Text = {attrs}: concatMapStrings (l: l + "\n") (mapAttrsToList formatGtk2Option attrs);
}
