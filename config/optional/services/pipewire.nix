{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = mkIf (config.local.vars.home.desktop.name != null) {
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
