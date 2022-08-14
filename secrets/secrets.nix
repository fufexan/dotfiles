let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH81M2NZOzd5tGGRsDv//wkSrVNJJpaiaLghPZBH8VTd";
  arm-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLg9Y7B9VNJ2VuZojs5TI2vPGKWYy9fpBV1zxr5LV8p root@instance-20220331-1829";
in {
  "synapse-registration-shared-secret.age".publicKeys = [mihai arm-server];
}
