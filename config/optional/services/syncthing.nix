{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.trivial) boolToString;
  inherit (builtins) concatStringsSep;
  inherit (lib.attrsets) mapAttrs' nameValuePair;

  stignore = let
    ignores = [
      "(?d)**/target"
      "(?d)**/node_modules"
      "(?d)**/site-packages"
      "**/.git"
      "**/.jj"
      "**/*.direnv"
    ];
  in
    pkgs.writeText "stignore-shared" (concatStringsSep "\n" ignores);
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    dataDir = config.hj.directory;
    user = config.local.vars.system.username;
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
    };
  };

  hj.files = mapAttrs' (n: _: nameValuePair "${n}/.stignore" {source = stignore;}) config.services.syncthing.settings.folders;
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = boolToString true;
}
