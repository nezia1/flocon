{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = _: {
    pre-commit.settings.hooks = {
      treefmt.enable = true;
      deadnix.enable = true;
      nil.enable = true;
      statix = {
        enable = true;
        settings = {
          ignore = ["**/npins/**/default.nix"];
        };
      };
    };
  };
}
