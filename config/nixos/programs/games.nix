{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    gamemode.enable = true;
    gamescope.enable = true;

    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };
  };
}
