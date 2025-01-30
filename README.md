<h1 id="header" align="center">
  <img src="assets/nix-snowflake-colors.svg" width="128px" height="128px" />
  <br>
  flocon
</h1>

My NixOS configurations, using flakes.

# 🛠️ Structure

| Name                | Description                                                      |
| ------------------- | ---------------------------------------------------------------- |
| [assets](assets/)   | Resources used throughout the system (images etc.)               |
| [hosts](hosts/)     | Host-specific                                                    |
| [modules](modules/) | Local module system (where the bulk of the configurations lives) |
| [shared](shared/)   | Exported components (so far only packages)                       |

My configuration is structured based on the following principles:

1. Hosts should be the main entry points and outputs.
2. Abstractions should be avoided as much as possible.
3. Setting up theming should be as simple as changing one or two options.

The main configuration can be found in [modules](modules/), which declares most of my programs and services.

My hosts can then pick and choose the programs and configurations that they need from the local module system, which have its options declared in [modules/options](modules/options/) for easy reference.

# 👥 Credits

People / repositories I have copied / learned from:

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) for the configuration structure
- [jacekpoz/nixos](https://git.jacekpoz.pl/poz/niksos) for learning how NixOS modules work
- [sodiboo](https://github.com/sodiboo) for helping me a whole lot with Niri-specific issues
- [llakala](https://github.com/llakala) for being very thorough and helpful when cleaning up my code and general structure.
- [Lunarnovaa](https://github.com/Lunarnovaa) for her [hjem](https://github.com/feel-co/hjem) configuration and functions, that I used when switching away from home-manager.

Some bits have also been borrowed from within the configuration, and credit has been given where its due.
