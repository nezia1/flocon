{pkgs, ...}: {
  services.dbus.packages = [pkgs.kdePackages.kwallet];
}
