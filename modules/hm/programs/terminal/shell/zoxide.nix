{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = false;
    };
  };
}
