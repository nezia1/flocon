{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = lib.mkIf config.local.profiles.desktop.enable {
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
  };
}
