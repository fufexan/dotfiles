let
  mihai =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/FGSeXJhOeTVrAdnvvnFumuRliSWii6HceY879bSS8";
  users = [ mihai ];

  kiiro =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFttID3OuB0labCpk6iezpoRE4OBl6hakqlmVTxQBxK/";
  homesv =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCVqhkw7Mn+zt9qEcoyTB8JtE/jH3PLR7b0HpcGgvCY";
  systems = [ kiiro homesv ];
in {
  "ddclientConfig.age".publicKeys = users ++ systems;
  "mailPass.age".publicKeys = users ++ systems;
  "mailPassPlain.age".publicKeys = users ++ systems;
}
