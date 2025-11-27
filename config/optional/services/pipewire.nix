{inputs, ...}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  services = {
    pulseaudio.enable = false;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
}
