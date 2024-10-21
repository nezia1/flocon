{pkgs, ...}: {
  home.packages = with pkgs; [
    bottles
    lutris
    mangohud
    path-of-building
    protonplus
    r2modman

    # steamtinkerlaunch dependencies
    xdotool
    xorg.xwininfo
    yad
  ];
}
