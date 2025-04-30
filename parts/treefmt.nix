{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = {pkgs, ...}: {
    treefmt = {
      projectRootFile = "flake.lock";
      programs = {
        alejandra.enable = true;
        mdformat = {
          enable = true;
          package = pkgs.mdformat.withPlugins (p: [p.mdformat-gfm]);
        };
        deadnix = {
          enable = true;
          package = pkgs.deadnix;
        };
      };
    };
  };
}
