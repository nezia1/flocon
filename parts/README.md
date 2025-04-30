# Structure

| Name                               | Description                                                                                                             |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| [npins/](npins/)                   | Non-flake inputs, managed using [npins](https://github.com/andir/npins)                                                 |
| [pkgs/](pkgs/)                     | Exported packages                                                                                                       |
| [args.nix](args.nix)               | Top-level non-standard arguments, passed directly into `_module.args`                                                   |
| [deployments.nix](deployments.nix) | Nodes to deploy remotely, using [deploy-rs](https://github.com/serokell/deploy-rs)                                      |
| [hooks.nix](hooks.nix)             | Git hooks, using [git-hooks.nix](https://github.com/cachix/git-hooks.nix)                                               |
| [modules.nix](modules.nix)         | Exported modules                                                                                                        |
| [shell.nix](shell.nix)             | Devshells available for this flake                                                                                      |
| [treefmt.nix](treefmt.nix)         | Formatters for this flake, available under `nix fmt` (powered by [treefmt-nix](https://github.com/numtide/treefmt-nix)) |
