{ inputs }:

final: prev: {
  discord-electron = prev.callPackage ./discord { branch = "stable"; };
  discord-electron-canary = prev.callPackage ./discord { branch = "canary"; };

  gnomeExtensions = prev.gnomeExtensions // {
    paperwm = prev.gnomeExtensions.paperwm.overrideAttrs (
      _: {
        version = "pre-40.0";
        src = inputs.paperwm;
        patches = ./paperwm.patch;
      }
    );
  };

  legendary-gl = prev.legendary-gl.overrideAttrs (
    o: rec {
      version = "0.20.9";
      src = prev.fetchFromGitHub {
        owner = "derrod";
        repo = "legendary";
        rev = version;
        sha256 = "sha256-22IxUAIMZxe3VhOE5460MTT0t+UWRtsNdPbakQ7dv8Y=";
      };
    }
  );

  # currently based on https://github.com/Ma27/rnix-lsp/tree/experimental.
  rnix-lsp = with final; rustPlatform.buildRustPackage {
    pname = "rnix-lsp-unstable";
    version = "2021-09-18";
    src = fetchFromGitHub {
      owner = "ma27";
      repo = "rnix-lsp";
      rev = "2136b1b7ca0f387451f34747609b21064220fd0a";
      sha256 = "sha256-IiJ8Sx0VEo/VmQPg/8jqAHttm1P+qLi2t1fQ3AJAbog=";
    };
    cargoPatches = [ ./rnix-fix.patch ];
    cargoSha256 = "sha256-yG9w7/RWKyPIqKpy9ULsd5MTsvjkaPBSH/bKfpYMu3U=";
    checkInputs = [ nixUnstable ];
  };

  orchis-theme = prev.callPackage ./orchis-theme { };

  picom = prev.picom.overrideAttrs (
    old: {
      version = "unstable-2021-08-04";
      src = inputs.picom;
    }
  );

  spotify-adblock = prev.callPackage ./spotify-adblock/wrapper.nix {
    spotify-adblocker = prev.callPackage ./spotify-adblock { };
  };
}
