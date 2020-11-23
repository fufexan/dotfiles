{ configs, pkgs, ... }:

{
	# enable DHCP
	networking = {
		useDHCP = false;
		interfaces.enp3s0.useDHCP = true;
	};
}
