{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = (mkIf (!config.local.profiles.server.enable)) {
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
