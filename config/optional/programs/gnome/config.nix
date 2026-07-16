{pkgs, ...}: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome = {
    games.enable = false;
    core-apps.enable = true;
    core-developer-tools.enable = false;
  };

  environment = {
    gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
    systemPackages = with pkgs.gnomeExtensions; [
      gsconnect
    ];
  };
}
