# 💻 Hosts

This directory contains the entry points for different NixOS system configurations. Each host represents a complete system configuration, combining NixOS system settings and Home Manager configurations.

## Components

### default.nix

The `default.nix` file in each host directory serves as the main entry point for the system configuration. It:

- Sets up NixOS configurations
- Sets up Home Manager configurations
- References host-specific module declarations

### modules/

The `modules/` directory contains host-specific declarations for custom modules that are defined in the flake's `nixosModules` output. This so far only includes global theme / style related declarations.

## Adding a New Host

1. Create a new directory for the host
1. Add a `hardware-configuration.nix` generated with `nixos-generate-config`
1. Add a `default.nix` that imports the desired configurations
1. Create host-specific module declarations in the `modules/` subdirectory to customize the global modules as needed
1. Reference the new host in `hosts/default.nix`
