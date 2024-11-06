_: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "cinny-4.2.2"
        "cinny-unwrapped-4.2.2"
        "segger-jlink-qt4-796s"
      ];
      segger-jlink.acceptLicense = true;
    };
  };
}
