# NixOS Configuration for HP LaserJet 1020

A dead-simple, reliable, and pure Nix-way workaround to make host-based HP printers work on NixOS in just 10 minutes. 

## Why this repository exists
Standard `hplipWithPlugin` often breaks after NixOS garbage collection, and standard `foo2zjs` automatic udev scripts fail due to `/nix/store` isolation. 

This configuration bypasses heavy HP software by using a local firmware file, a native `udev` rule, and pushes the firmware through CUPS via `lp -o raw`.

## How to use

1. Download the firmware file for your printer (e.g., `sihp1020.dl` for HP 1020) and place it in your home directory (e.g., `/home/YOUR_USERNAME/hp1020_firmware/sihp1020.dl`).
2. Copy `printing.nix` from this repository to your `/etc/nixos/` directory.
3. Import it into your main `configuration.nix`:
   ```nix
   imports = [ ./printing.nix ];
   ```
4. Run `sudo nixos-rebuild switch`.
5. Plug in your printer and print!

*Note: Make sure to adjust the hardcoded home path and printer network name inside `printing.nix` if your system detects it differently.*
