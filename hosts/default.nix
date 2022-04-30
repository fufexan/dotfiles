inputs: let
  inherit (inputs) self;

  sharedModules = [
    {_module.args = {inherit inputs;};}
    ../modules/minimal.nix
    ../modules/security.nix
    inputs.hm.nixosModule
    {
      home-manager = {
        inherit (inputs.self.lib) extraSpecialArgs;
        useGlobalPkgs = true;
      };
    }
  ];

  desktopModules = [
    inputs.kmonad.nixosModule
    inputs.nix-gaming.nixosModules.default
  ];

  inherit (self.lib) nixosSystem makeOverridable;
  inherit (import "${self}/home/profiles" inputs) homeImports;
in {
  io = nixosSystem {
    modules =
      [
        ./io
        ../modules/desktop.nix
        ../modules/gamemode.nix
        ../modules/gnome.nix
        {home-manager.users.mihai.imports = homeImports."mihai@io";}
      ]
      ++ sharedModules
      ++ desktopModules;

    system = "x86_64-linux";
  };

  homesv = nixosSystem {
    modules =
      [
        ./homesv
        {home-manager.users.mihai.imports = homeImports.server;}
      ]
      ++ sharedModules;

    system = "x86_64-linux";
  };

  /*
   iso = makeOverridable nixosSystem {
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
   };
   */

  kiiro = nixosSystem {
    modules =
      [
        ./kiiro
        {home-manager.users.mihai.imports = homeImports.server;}
      ]
      ++ sharedModules;

    system = "x86_64-linux";
  };

  tosh = nixosSystem {
    modules =
      [
        ./tosh
        ../modules/desktop.nix
        {home-manager.users.mihai.imports = homeImports."mihai@tosh";}
      ]
      ++ sharedModules
      ++ desktopModules;

    system = "x86_64-linux";
  };

  # servers
  arm-server = nixosSystem {
    modules =
      [
        ./servers/arm-server
        {home-manager.users.mihai.imports = homeImports.server;}
      ]
      ++ sharedModules;

    system = "aarch64-linux";
  };
}
