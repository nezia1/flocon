{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.lock";
      flakeCheck = false; # handled by git-hooks.nix
      programs = {
        alejandra.enable = true;
        deadnix = {
          enable = true;
          no-lambda-pattern-names = true;
        };
        deno.enable = true;
      };

      settings = {
        formatter.deno.excludes = ["*.css"];
      };
    };
  };
}
