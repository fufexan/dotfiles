self: super:
{
	bspwm = super.bspwm.overrideAttrs (old: {
		src = super.fetchFromGitHub {
			owner = "dylanaraps";
			repo = "bspwm";
			rev = "dbb8ca50aab303a62983ec76acfc3d0b8808c5e0";
			sha256 = "0v7css32z63i5lp5zcx8pz377q798fwndjbnfnrw520pnhc8k90n";
		};
	});
}
