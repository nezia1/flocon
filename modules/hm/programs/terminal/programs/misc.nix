{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    home.packages = with pkgs; [
      # archives
      zip
      unzip
      unrar

      # utils
      fd
      file
      ripgrep
    ];
  };
}
