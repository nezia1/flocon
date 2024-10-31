{
  inputs,
  pkgs,
  ...
}: {
  imports = [./docker.nix ./gnupg.nix ./pipewire.nix ./kmscon.nix];
  services.udev.packages = [pkgs.segger-jlink inputs.self.packages.${pkgs.system}.mcuxpresso.ide];
}
