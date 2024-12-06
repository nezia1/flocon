{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.bottles
    pkgs.mangohud
    pkgs.protonplus

    # steamtinkerlaunch dependencies
    pkgs.wget
    pkgs.xdotool
    pkgs.xorg.xrandr
    pkgs.xorg.xprop
    pkgs.xorg.xwininfo
    pkgs.xxd
    pkgs.yad

    inputs.self.packages.${pkgs.system}.bolt-launcher
    inputs.self.packages.${pkgs.system}.ankama-launcher
  ];
}
