{ configs, pkgs, ... }:

{
	# configure zsh (not default shell)
	programs.zsh = {
		enable = true;

		# plugins
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;

		# zsh options
		enableGlobalCompInit = true;
		setOptions = [
			"APPEND_HISTORY"
			"AUTO_CD"
			"GLOB_COMPLETE"
			"HIST_FIND_NO_DUPS"
			"HIST_IGNORE_DUPS"
			"INC_APPEND_HISTORY"
			"NO_CASE_GLOB"
			"SHARE_HISTORY"
		];
		histFile = "$HOME/.cache/.histfile";
	};
}
