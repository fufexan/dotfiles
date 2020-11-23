{ configs, pkgs, ... }:

{
	fonts = {
		fonts = with pkgs; [
			font-awesome
			material-icons
			noto-fonts
			noto-fonts-cjk
			gohufont
			roboto
			tewi-font
			(nerdfonts.override { fonts = [ "FiraCode" "Mononoki" ]; })
		];

		enableDefaultFonts = true;

		fontconfig.defaultFonts = {
			serif = [ "Noto Serif" "DejaVu Serif" ];
			sansSerif = [ "Noto Sans" "DejaVu Sans" ];
			monospace = [ "mononoki Nerd Font" "DejaVu Sans Mono" ];
		};
	};
}
