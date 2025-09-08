{pkgs, ...}: {
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr
  ];
}
