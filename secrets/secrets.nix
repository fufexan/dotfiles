let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/FGSeXJhOeTVrAdnvvnFumuRliSWii6HceY879bSS8";
  users = [ mihai ];

  kiiro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFttID3OuB0labCpk6iezpoRE4OBl6hakqlmVTxQBxK/";
  homesv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgImuadR6T5kyoAsUwN2QvtcUvD9TUrvBQYX9ySxLwC";
  tosh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGW92k84ycf5tlgeyRVt8Mq8SrHRehK69tdNlzVD6su";
  systems = [ kiiro homesv tosh ];
in
{
  "ddclientConfig.age".publicKeys = users ++ systems; #[ mihai homesv ];
  "mailPass.age".publicKeys = users ++ systems; #[ mihai homesv ];
  "mailPassPlain.age".publicKeys = users ++ systems;
  "vaultwarden.age".publicKeys = users ++ systems; #[ mihai homesv ];
}
