{
  perSystem = {pkgs, ...}: let
    treefmt = pkgs.treefmt.withConfig {
      settings = {
        tree-root-file = "flake.nix";
        formatter = {
          alejandra = {
            command = "alejandra";
            includes = ["*.nix"];
          };
          deadnix = {
            command = "deadnix";
            options = ["--edit" "--no-lambda-arg" "--no-lambda-pattern-names"];
            includes = ["*.nix"];
          };
          deno = {
            command = "deno";
            options = ["fmt"];
            includes = ["*.md"];
            excludes = ["*.css"];
          };
        };
      };
      runtimeInputs = builtins.attrValues {
        inherit
          (pkgs)
          deno
          alejandra
          deadnix
          ;
      };
    };
  in {
    formatter = treefmt;
  };
}
