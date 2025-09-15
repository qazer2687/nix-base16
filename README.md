### nix-base16
Minimal wrapper for Base16 schemes on NixOS. 🎨

---

### Usage

```nix
# configuration.nix
{ config, pkgs, base16, ... }:

let
  # choose any scheme in the flake by filename
  gruvbox = base16 "gruvbox";
in {
  console.colors = [
    gruvbox.base00 gruvbox.base08 gruvbox.base0B gruvbox.base0A
    gruvbox.base0D gruvbox.base0E gruvbox.base0C gruvbox.base05
    gruvbox.base03 gruvbox.base08 gruvbox.base0B gruvbox.base0A
    gruvbox.base0D gruvbox.base0E gruvbox.base0C gruvbox.base07
  ];
}
```
