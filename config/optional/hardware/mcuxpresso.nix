{self', ...}: {
  services.udev.packages = [self'.packages.mcuxpressoide];
}
