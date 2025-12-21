let
  rate = 48000;
  quantum = 64;
  qr = "${toString quantum}/${toString rate}";
in {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = rate;
          "default.clock.quantum" = quantum;
          "default.clock.min-quantum" = quantum;
          "default.clock.max-quantum" = quantum;
        };
      };

      pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {};
          }
        ];
        "pulse.properties" = {
          "pulse.min.req" = qr;
          "pulse.default.req" = qr;
          "pulse.max.req" = qr;
          "pulse.min.quantum" = qr;
          "pulse.max.quantum" = qr;
        };
        "stream.properties" = {
          "node.latency" = qr;
          "resample.quality" = 1;
        };
      };
    };
  };
}
