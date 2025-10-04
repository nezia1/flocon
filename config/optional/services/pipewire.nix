{
  inputs,
  pkgs,
  ...
}: {
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

      extraConfig.pipewire = {
        "60-normalizer" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Normalizer Sink";
                "media.name" = "Normalizer Sink";
                "filter.graph" = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "limiter";
                      plugin = "${pkgs.ladspaPlugins}/lib/ladspa/fast_lookahead_limiter_1913.so";
                      label = "fastLookaheadLimiter";
                      control = {
                        "Input gain (dB)" = 0;
                        "Limit (dB)" = -20;
                        "Release time (s)" = 0.3;
                      };
                    }
                  ];
                  inputs = [
                    "limiter:Input 1"
                    "limiter:Input 2"
                  ];
                  outputs = [
                    "limiter:Output 1"
                    "limiter:Output 2"
                  ];
                };
                "capture.props" = {
                  "node.name" = "effect_input.normalizer";
                  "media.class" = "Audio/Sink";
                  "audio.channels" = 2;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.name" = "effect_output.normalizer";
                  "node.passive" = true;
                  "audio.channels" = 2;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "node.target" = "@DEFAULT_SINK@";
                };
              };
            }
          ];
        };
      };
    };
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
}
