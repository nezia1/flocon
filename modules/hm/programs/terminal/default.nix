{
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./emulators
    ./programs
    ./shell
  ];

  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
