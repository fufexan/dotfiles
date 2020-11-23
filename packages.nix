{ configs, pkgs, ... }:

{
	# Allow the installation of unfree software.
	nixpkgs.config.allowUnfree = true;
	
	environment.systemPackages = with pkgs; [
		# general utils
		curl neovim gotop git gnupg nodejs ranger fzf ripgrep tree usbutils
		killall pass p7zip unzip unrar

		# terminal emulators
		alacritty 

		# browsers
		firefox qutebrowser

		# night light
		redshift

		# themes
		plata-theme capitaine-cursors kdeFrameworks.breeze-icons

		# games
		lutris steam

		# music and media
		mpd mpdris2 ncmpcpp mpv youtube-dl playerctl mps-youtube ffmpeg pavucontrol

		# messaging
		tdesktop discord discord-rpc zoom-us

		# integrations
		syncthing kdeApplications.kdeconnect-kde

		# IMEs
		ibus ibus-engines.anthy

		# wine
		wineWowPackages.staging wineWowPackages.fonts winetricks
	];
	
	# programs configuration
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};
}
