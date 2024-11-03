_: {
  nixpkgs = {
    overlays = [
      (_: prev: {
        lib =
          prev.lib
          // import ../../lib {
            inherit (prev) lib pkgs;
          };
      })
    ];

    config = {
      allowUnfree = true;
      permittedInsecurePackages = ["cinny-4.2.2" "cinny-unwrapped-4.2.2" "segger-jlink-qt4-796s" "openssl-1.1.1w"];
      segger-jlink.acceptLicense = true;
    };
  };
}
