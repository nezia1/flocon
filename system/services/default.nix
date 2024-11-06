{pkgs, ...}: {
  imports = [
    ./docker.nix
    ./gnupg.nix
    ./pipewire.nix
    ./kmscon.nix
  ];
  services.udev.packages = [pkgs.segger-jlink];
}
