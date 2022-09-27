let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH81M2NZOzd5tGGRsDv//wkSrVNJJpaiaLghPZBH8VTd";

  io = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRDsoSresP7/VnrQOYsWWO/5V+EdPEx5PwI0DxW9H00 root@io";
in {
  "spotify.age".publicKeys = [mihai io];
}
