inputs: let
  inherit (inputs) self;
  inherit (self.lib) nixosSystem;
  inherit (import "${self}/home/profiles" inputs) homeImports;
  inherit (import "${self}/theme" inputs) default;

  sharedModules = [
    {
      _module.args = {inherit inputs default;};
      home-manager = {
        extraSpecialArgs = {inherit inputs default;};
        useGlobalPkgs = true;
      };
    }
    ../modules/minimal.nix
    ../modules/nix.nix
    ../modules/security.nix
    inputs.agenix.nixosModule
    inputs.hm.nixosModule
  ];

  desktopModules = [
    inputs.hyprland.nixosModules.default
    inputs.kmonad.nixosModules.default
    inputs.nix-gaming.nixosModules.default
  ];
in {
  io = nixosSystem {
    modules =
      [
        ./io
        ../modules/greetd.nix
        ../modules/desktop.nix
        ../modules/gamemode.nix
        {home-manager.users.mihai.imports = homeImports."mihai@io";}
        inputs.waveforms-flake.nixosModule
      ]
      ++ sharedModules
      ++ desktopModules;

    system = "x86_64-linux";
  };

  kiiro = nixosSystem {
    modules =
      [
        ./kiiro
        {home-manager.users.mihai.imports = homeImports.server;}
      ]
      ++ sharedModules;

    system = "x86_64-linux";
  };
}
