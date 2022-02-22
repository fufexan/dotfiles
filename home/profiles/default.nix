inputs:

let
  inherit (inputs) self;
  inherit (self.lib) mkHome;

  sharedModules = [
    ../.
    ../files
    ../games.nix
    ../media.nix
    ../editors/helix
    inputs.nix-colors.homeManagerModule
  ];
  
  homeImports = {
    "mihai@io" = sharedModules ++ [ ../wayland ./mihai-io ];
    "mihai@kiiro" = [ ../cli.nix ];
    "mihai@tosh" = sharedModules ++ [ ../wayland ./mihai-tosh ];
  };
in
{
  inherit homeImports;
    
  homeConfigurations = {
    "mihai@io" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@io";
    };
    
    "mihai@kiiro" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@kiiro";
    };
      
    "mihai@tosh" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@tosh";
    };
  };
}
