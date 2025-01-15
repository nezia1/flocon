{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
