outputs = {...}: {
  base16 = name:
    let
      parseYaml = yamlContent:
        let
          # Remove Windows line endings and split
          lines = builtins.filter (l: l != "") 
            (builtins.split "\n" (builtins.replaceStrings ["\r"] [""] yamlContent));
          
          # Find palette section (safe version)
          paletteMatches = builtins.filter 
            (i: let line = builtins.elemAt lines i;
             in builtins.match "^ *palette:" line != null)
            (builtins.genList (i: i) (builtins.length lines));
          
          paletteStart = if builtins.length paletteMatches > 0 
            then builtins.head paletteMatches 
            else throw "No 'palette:' section found in YAML";
          
          # Get lines after palette
          linesAfterPalette = builtins.genList 
            (i: builtins.elemAt lines (paletteStart + 1 + i))
            (builtins.length lines - paletteStart - 1);
          
          # Parse a color line: "  base00: "#000000" # comment"
          parseColorLine = line:
            let
              # Match key and hex value
              keyMatch = builtins.match "^ *([a-z0-9]+):" line;
              hexMatch = builtins.match "#([0-9A-Fa-f]{6})" line;
            in
              if keyMatch != null && hexMatch != null
              then { ${builtins.head keyMatch} = builtins.head hexMatch; }
              else {};
          
          # Filter lines that look like colors
          colorLines = builtins.filter
            (line: builtins.match "^ *base[0-9A-Fa-f]{2}:" line != null)
            linesAfterPalette;
        in
          builtins.foldl' (acc: line: acc // parseColorLine line) {} colorLines;
      
      schemes = builtins.listToAttrs (
        map
          (file: let
            schemeName = builtins.replaceStrings [".yaml"] [""] file;
          in {
            inherit schemeName;
            value = parseYaml (builtins.readFile (./. + "/schemes/${file}"));
          })
          (builtins.filter 
            (f: builtins.match ".*\\.yaml" f != null)
            (builtins.attrNames (builtins.readDir ./schemes)))
      );
    in
      builtins.getAttr name schemes;
};