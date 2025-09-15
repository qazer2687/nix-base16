{
  outputs = {...}: {
    base16 = name:
      builtins.getAttr name (builtins.listToAttrs (
        map
          (file: let
            s = import (./. + "/schemes/" + file) {};
            n = builtins.replaceStrings [".nix"] [""] file;
          in {
            name = n;
            value = s;
          })
          (builtins.attrNames (builtins.readDir ./schemes))
      ));
  };
}