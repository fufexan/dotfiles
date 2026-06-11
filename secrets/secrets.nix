let
  identities = import ./identities.nix;
in
{
  "spotify.age".publicKeys = with identities; [
    mihai
    io
  ];
}
