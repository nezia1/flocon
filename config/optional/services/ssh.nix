{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  hj = {
    environment.sessionVariables = {
      SSH_ASKPASS = getExe pkgs.kdePackages.ksshaskpass;
      SSH_ASKPASS_REQUIRE = "prefer";
    };
    files = {
      ".ssh/config".text = ''
        AddKeysToAgent yes
      '';
    };
  };
}
