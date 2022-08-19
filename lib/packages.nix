lib: let
  # create list of single-attribute sets that contain each package
  exportPackagesList = overlay: pkgs:
    map
    (
      name: let
        item = pkgs.${name};
        exportItem = {${name} = item;};
      in
        if item ? type && item.type == "derivation"
        then
          # if its a package export it
          exportItem
        else if item ? __dontExport && !item.__dontExport
        then
          # if its a package sub-system, __dontExport has to be set to false to export
          exportItem
        else {}
    )
    overlay;

  # fold list into one attribute set
  exportPackages = lib.foldl' (lhs: rhs: lhs // rhs) {} exportPackagesList;
in
  exportPackages
