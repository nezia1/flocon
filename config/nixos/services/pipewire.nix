{inputs, ...}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      lowLatency.enable = true;
    };
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
}
