{pkgs, ...}: {
  # temp disable while system doesn't rebuild because of vbox
  # virtualisation.virtualbox.host.enable = true;

  environment.systemPackages = [pkgs.gnome.gnome-boxes];
  virtualisation.libvirtd.enable = true;
}
