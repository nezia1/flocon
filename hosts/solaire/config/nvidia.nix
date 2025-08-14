{config, ...}: {
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  programs.coolercontrol.nvidiaSupport = true;
  hj.environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
  };

  # https://wiki.hyprland.org/Nvidia/#suspendwakeup-issues
  boot.kernelParams = [
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
}
