# ❄️ flocon

My NixOS configurations, using flakes.

# </> Software I use

- Wayland compositor: [niri](https://github.com/YaLTeR/niri)
- Text editor: [neovim](https://github.com/neovim/neovim)
- Shell: [fish](https://github.com/fish-shell/fish-shell)
- Colors: [Catppuccin](https://github.com/catppuccin/catppuccin)
- Font: [Intel One Mono](https://github.com/intel/intel-one-mono)

Additionally using a lot of other software you can find in the configuration files.

# 🛠️ Structure

| Name                | Description                |
| ------------------- | -------------------------- |
| [home](home/)       | Home manager configuration |
| [hosts](hosts/)     | Host-specific              |
| [lib](lib/)         | Helper functions           |
| [modules](modules/) | NixOS modules              |
| [pkgs](pkgs/)       | Custom packages            |
| [system](system/)   | NixOS configuration        |

My configuration is structured based on the following principles:

1. Hosts should be the main entry points and outputs.
2. Abstractions should be avoided as much as possible.

The bulk of the configuration can be found either in [home](home/) or [system](system/), which declares most of my programs, with some extra Nix code in [lib](lib/) and custom [modules](modules/), mostly for convenience and to provide a way to globally set styles and themes for now.

My hosts can then pick and choose the programs and configurations that they need from the other directories. If the need arises for a more modular setup for a specific piece of software (ie. having different flavors of Firefox per host), I will write a custom module for it. This helps to avoid unnecessarily abstracting my configuration, as I don't find it necessary for the most part, and I would also like it to remain as simple as possible.

# 👥 Credits

People / repositories I have copied / learned from:

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) for the configuration structure
- [jacekpoz/nixos](https://git.jacekpoz.pl/poz/niksos) for learning how NixOS modules work

Some bits have also been borrowed from within the configuration, and credit has been given where its due.
