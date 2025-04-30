{lib, ...}: {
  imports = lib.filesystem.listFilesRecursive ./rum;
}
