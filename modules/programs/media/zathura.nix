{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) concatStringsSep toString;
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;

  toZathura = attrs:
    concatStringsSep "\n"
    (lib.mapAttrsToList (option: value: "set ${option} \"${toString value}\"") attrs);
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.zathura];
      files = {
        ".config/zathura/zathurarc".text = toZathura {
          font = "sans-serif 12";
          selection-notification = true;

          selection-clipboard = "clipboard";
          adjust-open = "best-fit";
          pages-per-row = "1";
          scroll-page-aware = "true";
          scroll-full-overlap = "0.01";
          scroll-step = "100";
          zoom-min = "10";
        };
      };
    };
  };
}
