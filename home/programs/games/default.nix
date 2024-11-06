{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.bottles
    pkgs.lutris
    pkgs.mangohud
    pkgs.path-of-building
    pkgs.protonplus
    pkgs.r2modman

    # steamtinkerlaunch dependencies
    pkgs.xdotool
    pkgs.xorg.xwininfo
    pkgs.yad

    inputs.self.packages.${pkgs.system}.bolt-launcher
  ];
}
