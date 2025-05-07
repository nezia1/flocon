{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
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
