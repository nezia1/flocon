{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = {pkgs, ...}: {
    treefmt = {
      projectRootFile = "flake.lock";
      flakeCheck = false; # handled by git-hooks.nix
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        mdformat = {
          enable = true;
          package = pkgs.mdformat.withPlugins (p: [p.mdformat-gfm]);
        };
      };
    };
  };
}
