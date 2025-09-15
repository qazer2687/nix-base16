{
  outputs = {...}: {
    base16 = name:
      let
        scheme = builtins.getAttr name (builtins.listToAttrs (
          map
          (file: let
            s = import (./. + "/schemes/${file}");
            n = builtins.replaceStrings [".nix"] [""] file;
          in {
            name = n;
            value = s;
          })
          (builtins.attrNames (builtins.readDir ./schemes))
        ));
      in
        builtins.mapAttrs (_: value: 
          if builtins.isString value && builtins.substring 0 1 value == "#"
          then builtins.substring 1 (-1) value
          else value
        ) scheme;
  };
}