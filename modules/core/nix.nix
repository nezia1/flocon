{
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
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
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 3";
    };
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

  hjem.users.${username}.environment.sessionVariables.FLAKE = "${config.hjem.users.${username}.directory}/.dotfiles";
}
