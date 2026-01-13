{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.musnix.nixosModules.default];
  security.rtkit.enable = true;

  musnix = {
    enable = true;
    rtcqs.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;
    socketActivation = true;
    wireplumber.enable = true;
  };

  hj.packages = with pkgs; [
    bitwig-studio
    qpwgraph
  ];
}
