{inputs, ...}: {
  imports = [
    inputs.hm.nixosModule
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
