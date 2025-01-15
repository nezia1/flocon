{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    services.kmscon = {
      enable = true;
      fonts = [
        {
          name = "0xProto Nerd Font";
          package = pkgs.nerd-fonts._0xproto;
        }
      ];
      extraConfig = ''
        font-size=13
        font-dpi=144
      '';
    };
  };
}
