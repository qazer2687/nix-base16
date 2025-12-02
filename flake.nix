{
  inputs = {};

  outputs = _: {
    base16 = name: 
      builtins.foldl' (acc: line:
        let m = builtins.match "base([0-9A-Fa-f]{2}): \"#?([0-9A-Fa-f]{6})\"" line;
        in if m != null then acc // { ${"base" + builtins.head m} = builtins.elemAt m 1; } else acc)
      {} (builtins.filter builtins.isString (builtins.split "\n" (builtins.readFile ./schemes/${name}.yaml)));
  };
}