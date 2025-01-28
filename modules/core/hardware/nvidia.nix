{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.local.modules.nvidia.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # https://wiki.hyprland.org/Nvidia/#suspendwakeup-issues
    boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  };
}
