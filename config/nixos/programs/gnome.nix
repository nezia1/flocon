{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.mutter];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    gnome-photos
    gnome-tour
    gnome-software
    iagno
    hitori
    atomix
    gnome-contacts
    gnome-initial-setup
    gnome-terminal
    gnome-music
    gedit
    cheese
    tali
    epiphany
    geary
    yelp
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-power-manager
    rhythmbox
  ];
}
