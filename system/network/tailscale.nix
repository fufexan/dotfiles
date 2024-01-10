{
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    # required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };

  # inter-machine VPN
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
