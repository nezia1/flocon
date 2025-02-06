{
  inputs,
  pkgs,
  config,
  ...
}: {
  nix = {
    package = pkgs.lix;
    settings = {
      accept-flake-config = true;
      warn-dirty = false;
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
        "segger-jlink-qt4-810"
      ];
      segger-jlink.acceptLicense = true;
    };
  };
}
