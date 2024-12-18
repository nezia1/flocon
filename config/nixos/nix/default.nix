{pkgs, ...}: {
  imports = [./nixpkgs.nix ./nh.nix];
  environment.systemPackages = [pkgs.git];
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
}
