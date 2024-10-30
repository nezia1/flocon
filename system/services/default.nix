{
  inputs,
  pkgs,
  ...
}: {
  imports = [./docker.nix ./gnupg.nix ./pipewire.nix ./kmscon.nix];
  services.udev.packages = [pkgs.segger-jlink inputs.self.packages.${pkgs.system}.mcuxpresso.ide];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1fc9", ATTR{idProduct}=="0132", MODE="0666"
  '';
}
