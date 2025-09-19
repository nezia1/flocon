{lib, ...}: let
  inherit (lib.trivial) boolToString;
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        "solaire" = {id = "LKYQO62-4ZVQEDL-45VPUCQ-6MIGIMT-SXBWVUR-FAQR25U-J7XYCGX-ZITOZQY";};
        "vamos" = {id = "WMQX2CE-GU7VKQZ-TOEY6Q3-47W2LVY-MX7YBPO-YKZU64N-E3EVJJF-4B2BIAW";};
      };
      folders = {
        "Documents" = {
          path = "~/Documents";
          devices = ["solaire" "vamos"];
        };
        "Pictures" = {
          path = "~/Pictures";
          devices = ["solaire" "vamos"];
        };
      };
      ignores = [
        ".git"
        ".jj"
        "node_modules"
        ".direnv"
      ];
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = boolToString true;
}
