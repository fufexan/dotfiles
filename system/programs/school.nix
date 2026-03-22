{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ virt-manager ];
  users.users.mihai.extraGroups = [
    "docker"
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
