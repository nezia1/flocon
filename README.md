<h1 id="header" align="center">
  <img src="assets/nix-snowflake-colors.svg" width="128px" height="128px" />
  <br>
  flocon
</h1>

My NixOS configurations, using flakes.

# </> Software I use

- Wayland compositor: [Hyprland](https://github.com/hyprwm/Hyprland)
- Text editor: [neovim](https://github.com/neovim/neovim)
- Shell: [fish](https://github.com/fish-shell/fish-shell)

Additionally using a lot of other software you can find in the configuration files.

# 🛠️ Structure

| Name              | Description                                                   |
| ----------------- | ------------------------------------------------------------- |
| [assets](assets/) | Resources used throughout the system (images etc.)            |
| [config](config/) | System configuration (separated between NixOS / home-manager) |
| [hosts](hosts/)   | Host-specific                                                 |
| [lib](lib/)       | Helper functions                                              |
| [shared](shared/) | Re-used components (internal modules, custom derivations)     |

My configuration is structured based on the following principles:

1. Hosts should be the main entry points and outputs.
2. Abstractions should be avoided as much as possible.
3. Setting up theming should be as simple as changing one or two options.

The main configuration can be found in [config](config/), which declares most of my programs, with re-usable modules and derivations in [shared](shared/), to provide a way to globally set themes, usernames and more.

My hosts can then pick and choose the programs and configurations that they need from the other directories. If the need arises for a more modular setup for a specific piece of software (ie. having different flavors of Firefox per host), I will write a custom module for it. This helps to avoid unnecessarily abstracting my configuration, as I don't find it necessary for the most part, and I would also like it to remain as simple as possible.

# 👥 Credits

People / repositories I have copied / learned from:

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) for the configuration structure
- [jacekpoz/nixos](https://git.jacekpoz.pl/poz/niksos) for learning how NixOS modules work
- [sodiboo](https://github.com/sodiboo) for helping me a whole lot with Niri-specific issues
- [llakala](https://github.com/llakala) for being very thorough and helpful when cleaning up my code and general structure.

  Some bits have also been borrowed from within the configuration, and credit has been given where its due.
