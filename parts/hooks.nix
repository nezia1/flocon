{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = _: {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
        treefmt.enable = true;
      };
    };
  };
}
