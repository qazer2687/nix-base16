### nix-base16
Minimal wrapper for Base16 schemes on NixOS. 🎨

---

### Usage

```nix
# configuration.nix
{ config, pkgs, base16, ... }:

let
  # choose any scheme in the flake by filename
  scheme = base16 "gruvbox";
in {
  console.colors = [
    scheme.base00 scheme.base08 scheme.base0B scheme.base0A
    scheme.base0D scheme.base0E scheme.base0C scheme.base05
    scheme.base03 scheme.base08 scheme.base0B scheme.base0A
    scheme.base0D scheme.base0E scheme.base0C scheme.base07
  ];
}
```
