{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        add_newline = true;
      };
    };
  };
}
