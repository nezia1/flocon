{
  inputs,
  pkgs,
  ...
}: {
  services.udev.packages = [
    (inputs.self.packages.${pkgs.system}.mcuxpresso.ide.override
      {
        onlyUdevRules = true;
      })
  ];
}
