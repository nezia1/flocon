{
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.vars.system) username;
in {
  age.secrets.nix-access-tokens-github = {
    file = ../../secrets/nix-access-tokens-github.age;
    # needs to be user readable
    mode = "0500";
    owner = username;
  };

  environment.systemPackages = [
    pkgs.nix-output-monitor
  ];

  nix = {
    settings = {
      accept-flake-config = true;
      warn-dirty = false;
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 60d";
      };
    };
    registry = {
      self.flake = inputs.self;
    };
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    extraOptions = ''
      !include ${config.age.secrets.nix-access-tokens-github.path}
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "libsoup-2.74.3"
        # stremio
        "qtwebengine-5.15.19"
      ];
      segger-jlink.acceptLicense = true;
    };
  };
  programs.nix-ld.enable = true;
}
