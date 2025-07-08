{pkgs, ...}: {
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [
      pkgs.gnome-settings-daemon
    ];

    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
  };
  programs.seahorse.enable = true;
}
