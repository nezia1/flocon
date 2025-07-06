_: let
  port = "9999";
in {
  services = {
    uptime-kuma = {
      enable = true;
      settings = {PORT = port;};
    };

    caddy.virtualHosts."uptime.nezia.dev".extraConfig = ''
      reverse_proxy localhost:${port}
    '';
  };
}
