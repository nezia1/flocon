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
    package = pkgs.lix;
    settings = {
      accept-flake-config = true;
      warn-dirty = false;
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
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
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
        "segger-jlink-qt4-810"
      ];
      segger-jlink.acceptLicense = true;
    };
  };
  programs.nix-ld.enable = true;
}
