{
  outputs = {...}: {
    base16 = name:
      let
        parseYaml = yamlContent:
          let
            lines = builtins.filter (l: l != "") (builtins.split "\n" yamlContent);
            
            paletteStart = builtins.elemAt (builtins.filter 
              (i: builtins.match "palette:.*" (builtins.elemAt lines i) != null)
              (builtins.genList (i: i) (builtins.length lines))
            ) 0;
            
            paletteLines = builtins.filter
              (line: builtins.match " +base[0-9A-F]{2}: \"#[0-9A-Fa-f]{6}\"" line != null)
              (builtins.genList (i: builtins.elemAt lines (paletteStart + 1 + i)) 
                (builtins.length lines - paletteStart - 1));
            

            parseColorLine = line:
              let
                trimmed = builtins.replaceStrings [" " "\""] ["" ""] line;
                parts = builtins.split ":" trimmed;
                colorName = builtins.elemAt parts 0;
                # remove hashtag
                colorValue = builtins.substring 1 (-1) (builtins.elemAt parts 2);
              in { name = colorName; value = colorValue; };
          in
            builtins.listToAttrs (map parseColorLine paletteLines);
        
        schemes = builtins.listToAttrs (
          map
            (file: let
              schemeName = builtins.replaceStrings [".yaml"] [""] file;
              yamlContent = builtins.readFile (./. + "/schemes/${file}");
              scheme = parseYaml yamlContent;
            in {
              name = schemeName;
              value = scheme;
            })
            (builtins.filter 
              (f: builtins.match ".*\\.yaml" f != null)
              (builtins.attrNames (builtins.readDir ./schemes)))
        );
        
        scheme = builtins.getAttr name schemes;
      in
        scheme;
  };
}