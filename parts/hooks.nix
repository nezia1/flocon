{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
  ];
  perSystem = {config, ...}: {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
        treefmt = {
          enable = true;
          package = config.formatter;
        };
      };
    };
  };
}
