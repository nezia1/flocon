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
        pkgs.deploy-rs.deploy-rs
        inputs'.agenix.packages.default
        pkgs.npins
        self'.formatter
        pkgs.act
        pkgs.attic-client
      ];

      shellHook = config.pre-commit.installationScript;
    };
  };
}
