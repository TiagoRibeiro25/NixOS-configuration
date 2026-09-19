# NixOS Configuration

Personal NixOS configuration for a laptop with NVIDIA hybrid graphics.

## Structure

```
├── flake.nix              # Flake entry point
├── configuration.nix      # Main system configuration
├── programs.nix           # Programs and packages to install
├── services.nix           # Services configuration
├── nvidia-laptop.nix      # NVIDIA PRIME hybrid graphics
└── flatpaks.txt           # Flatpak apps to install
```

## Flatpak Apps

All Flatpak apps are listed in `flatpaks.txt`.

## Usage

To rebuild the system configuration:

```bash
sudo nixos-rebuild switch --flake .
```
