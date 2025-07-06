_: {
  services.anubis = {
    defaultOptions = {
      botPolicy = {dnsbl = false;};
      settings = {
        DIFFICULTY = 4;
        SERVE_ROBOTS_TXT = true;
      };
    };
  };
}
