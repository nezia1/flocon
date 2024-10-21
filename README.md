# ❄️ nix

My NixOS configurations, using flakes.

# </> Software I use

- Wayland compositor: [niri](https://github.com/YaLTeR/niri)
- Text editor: [neovim](https://github.com/neovim/neovim)
- Shell: [fish](https://github.com/fish-shell/fish-shell)
- Colors: [Catppuccin](https://github.com/catppuccin/catppuccin)
- Font: [Intel One Mono](https://github.com/intel/intel-one-mono)

Additionally using a lot of other software you can find in the configuration files.

# 🛠️ Structure

| Name                | Description                                       |
| ------------------- | ------------------------------------------------- |
| [home](home/)       | Home manager configuration                        |
| [hosts](hosts/)     | Host-specific (entry-points of the configuration) |
| [lib](lib/)         | Helper functions                                  |
| [modules](modules/) | NixOS modules                                     |
| [system](system/)   | NixOS configuration                               |

# 👥 Credits

People / repositories I have copied / learned from:

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) for the configuration structure
- [jacekpoz/nixos](https://git.jacekpoz.pl/poz/niksos) for learning how NixOS modules work

Some bits have also been borrowed from within the configuration, and credit has been given when its due.
