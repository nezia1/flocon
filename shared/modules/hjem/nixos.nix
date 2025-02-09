{lib}: let
  inherit (lib.filesystem) listFilesRecursive;
in {
  config = {
    hjem.extraModules = [
      {
        imports = listFilesRecursive ./collection;
      }
    ];
  };
}
