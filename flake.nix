{
  inputs = {};

  outputs = _: {
    base16 = name: 
      builtins.foldl' 
        (acc: line:
          let m = builtins.match ".*base([0-9A-F]{2}): \"([^\"]+)\".*" line;
          in if m != null then acc // { ${"base" + builtins.elemAt m 0} = builtins.elemAt m 1; } else acc)
        {}
        (builtins.filter builtins.isString (builtins.split "\n" (builtins.readFile ./schemes/${name}.yaml)));
  };
}