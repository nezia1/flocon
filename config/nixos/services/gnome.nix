{pkgs, ...}: {
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    gnome.gnome-keyring.enable = true;
    gnome.gnome-online-accounts.enable = true;
    accounts-daemon.enable = true;

    gvfs.enable = true;
  };
}
