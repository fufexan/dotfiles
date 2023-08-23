let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq9Gew1rgfdIyuriJ/Ne0B8FE1s8O/U2ajErVQLUDu9 mihai@io";

  io = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFMR4XHc7mhSs0Diy2gWtXurueQiQ1gKjyzW2fuqtqv root@io";
in {
  "spotify.age".publicKeys = [mihai io];
}
