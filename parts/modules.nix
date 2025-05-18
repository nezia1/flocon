_: {
  flake = {
    nixosModules = {
      gcr-ssh-agent = ../modules/shared/nixos/gcr-ssh-agent;
    };
    hjemModules = {
      rum.imports = [../modules/shared/hjem/hjem.nix];
    };
  };
}
