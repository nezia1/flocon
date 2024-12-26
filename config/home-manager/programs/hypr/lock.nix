{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
  };
}
