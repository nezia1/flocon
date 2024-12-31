{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.xdg-autostart.homeManagerModules.xdg-autostart
  ];

  xdg.autoStart.packages = with pkgs; [
    vesktop
  ];
}
