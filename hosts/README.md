# 💻 Hosts

This directory contains the entry points for different NixOS system
configurations. Each host represents a complete system configuration, combining
NixOS system settings and Home Manager configurations.

## Structure

Each host directory serves as the main entry point for the system configuration.
It contains:

- `vars.nix` -> sets up system critical variables
- `[style.nix]` -> if applicable, sets up theming for the system
- `hardware-configuration.nix` -> hardware configuration for a host, generated
  using `nixos-generate-config`
- `config/` -> contains host-specific configuration that will not be re-used
  anywhere else (eg. server configuration, nvidia driver...).
