inputs:

let
  inherit (inputs) self;

  sharedModules = [
    #../modules/minimal.nix
    inputs.hm.nixosModule
    inputs.kmonad.nixosModule
    inputs.nix-gaming.nixosModule
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs self;
          nix-colors = inputs.nix-colors.colorSchemes.horizon-terminal-dark;
        };
        useGlobalPkgs = true;
      };
    }
  ];
  
  inherit (self.lib) mkSystem nixosSystem makeOverridable;
  inherit (import "${self}/home/profiles" inputs) homeImports;
in
{
  io = mkSystem {
    modules = [
      ./io
      ../modules/desktop.nix
      ../modules/gamemode.nix
      ../modules/gnome.nix
      { home-manager.users.mihai.imports = homeImports."mihai@io"; }
    ] ++ sharedModules;
      
  };

  homesv = mkSystem {
    modules = [
      ./homesv
      { home-manager.users.mihai.imports = homeImports."mihai@kiiro"; }
    ] ++ sharedModules;
  };

  /*iso = makeOverridable mkSystem {
    system = "x86_64-linux";

    modules = [
      ../modules/iso.nix
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          users.mihai.imports = [
            ../home/cli.nix
            ../home/editors/helix
          ];
        };
      }
    ];

    specialArgs = { inherit inputs; };
  };*/

  kiiro = mkSystem {
    modules = [
      ./kiiro
      { home-manager.users.mihai.imports = homeImports."mihai@kiiro"; }
    ] ++ sharedModules;
  };

  tosh = mkSystem {
    modules = [
      ./tosh
      ../modules/desktop.nix
      { home-manager.users.mihai.imports = homeImports."mihai@tosh"; }
    ] ++ sharedModules;
  };
}
