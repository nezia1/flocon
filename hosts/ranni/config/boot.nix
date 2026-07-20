{lib, ...}: {
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = false;
      };
    };
    tmp.cleanOnBoot = true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
