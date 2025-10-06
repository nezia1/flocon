{
  nix.settings = {
    cores = 2;
    use-cgroups = true;
    experimental-features = [
      "cgroups"
    ];
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "80%";
  };
}
