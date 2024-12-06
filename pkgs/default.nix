{
  inputs,
  pkgs,
  ...
}: {
  #  mcuxpresso = import ./mcuxpresso pkgs;
  # this is unfortunately needed since bolt-launcher makes use of openssl-1.1.1w, and since it is not part of hosts, we have to add it this way
  bolt-launcher =
    (import inputs.nixpkgs {
      inherit (pkgs) system;
      config.permittedInsecurePackages = ["openssl-1.1.1w"];
    })
    .callPackage
    ./bolt-launcher.nix {};
  ankama-launcher = pkgs.callPackage ./ankama-launcher.nix {};
}
