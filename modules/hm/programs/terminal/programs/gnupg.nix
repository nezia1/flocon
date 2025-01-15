{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
