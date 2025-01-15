{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
