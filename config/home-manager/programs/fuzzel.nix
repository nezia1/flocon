{
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = lib.getExe pkgs.foot;
        layer = "overlay";
        launch-prefix = "uwsm app --";
      };
    };
  };
}
