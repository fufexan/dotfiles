self: super:
{
	picom = super.picom.overrideAttrs (old: {
		src = super.fetchFromGitHub {
			owner = "tryone144";
			repo = "compton";
			rev = "c67d7d7b2c36f29846c6693a2f39a2e191a2fcc4";
			sha256 = "1y1821islx0cg61z9kshs4mkvcp45bpkmzbll5zpzq84ycnqji2y";
		};
	});
}
