{pkgs, ...}: {
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    nvidia-vaapi-driver
    intel-media-driver
  ];
}
