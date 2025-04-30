_: {
  perSystem = {
    config,
    inputs',
    self',
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        inputs'.deploy-rs.packages.default
        inputs'.agenix.packages.default
        pkgs.npins
        self'.formatter
      ];

      shellHook = config.pre-commit.installationScript;
    };
  };
}
