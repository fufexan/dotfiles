{ configs, pkgs, ... }:

{
	# install packages specific to X
	environment.systemPackages = with pkgs; [
		# gui utils
		dunst feh flameshot polybarFull rofi rofi-emoji

		# cli utils
		xclip
	];

	# configure X
	services.xserver = {
		enable = true;
		
		# keyboard config
		# add more keyboard layouts (in xcb format)
		extraLayouts = {
			us = {
				description = "US-English";
				languages = [ "eng" ];
				symbolsFile = ./xkb/colemak_dh;
			};
			ro = {
				description = "Romanian";
				languages = [ "rou" ];
				symbolsFile = ./xkb/ro_colemak_dh;
			};
		};
		# default layout
		layout = "ro";
		# default variant
		xkbVariant = "colemak_dh";

		videoDrivers = [ "nvidia" ];

		# display manager setup
		displayManager = {
			lightdm.enable = true;
			defaultSession = "none+bspwm";
		};
		windowManager.bspwm.enable = true;

		# disable mouse acceleration
		libinput = {
			enable = true;
			accelProfile = "flat";
			accelSpeed = "0";
		};
	};
}
