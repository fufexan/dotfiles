{
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    buildMachines = [
      {
        hostName = "neushore";
        protocol = "ssh"; # ssh-ng not supported on this machine
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = ["benchmark" "nixos-test" "kvm" "big-parallel"];
        systems = ["aarch64-linux" "i686-linux" "x86_64-linux"];
      }
    ];
  };
}
