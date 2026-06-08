# gp_passengerCombat

**gp_passengerCombat** is an advanced and optimized (0.00 - 0.02ms on idle) combat script for FiveM that fixes and enhances the native GTA V vehicle shooting mechanics. It utilizes custom raycast and vector calculations to allow players to accurately shoot other passengers or the driver *within the same vehicle*. 

## Features
- **Precise Hit Detection:** Custom mathematical trajectory calculation to reliably hit players and NPCs inside the vehicle.
- **Dynamic Firing Modes:** Supports both precise aiming and blind firing. Can be restricted via the config.
- **First-Person Restriction:** Option to restrict interior shooting to First-Person (FP) mode. This prevents accidental friendly fire when players just want to do a regular drive-by in Third-Person.
- **`ox_inventory` Ammo Sync:** Built-in ammo synchronization for `ox_inventory` to prevent "ghost bullets", infinite ammo glitches, and desyncs.
- **Exploit-Proof:** Server-side validation to avoid exploiting events.
- **Standalone:** Framework agnostic! Does not require ESX, QBCore, or any other framework to work.

## Configuration
The script comes with a `config.lua` where you can tweak:
- Toggle First-Person only mode
- Enable/Disable blind firing
- Adjust headshot damage
- Modify the hit-registration radius (hitbox tolerance)

## Requirements
- **Framework:** None! (100% Standalone)
- **Library**: [ox_lib](https://github.com/overextended/ox_lib)
- **Optional:** [ox_inventory](https://github.com/overextended/ox_inventory) (Native ammo sync is already integrated out of the box)

## Video Showcase
- [Watch Showcase](https://youtu.be/ks1-l4too7I)

## Installation
- Add to resources folder
- Add `ensure gp_passengerCombat` to your config file