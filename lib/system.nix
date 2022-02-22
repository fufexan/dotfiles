inputs:

rec {
  supportedSystems = [ "x86_64-linux" ];

  forAllSystems = f:
    inputs.nixpkgs.lib.genAttrs supportedSystems (system: f system);

  nixpkgsFor = forAllSystems (system: overlays: import inputs.nixpkgs {
    inherit system overlays;
  });

  defArgs = { system = "x86_64-linux"; };

  mkSystem = args: inputs.nixpkgs.lib.nixosSystem (defArgs // args // { modules = [{ _module.args = { inherit inputs; }; }]; });
}
