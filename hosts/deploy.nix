inputs: {
  nodes = with inputs.deploy-rs.lib.x86_64-linux; {
    arm-server = {
      hostname = "arm-server";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.arm-server;
      };
      sshOpts = ["-i" "/etc/ssh/ssh_host_ed25519_key"];
      sshUser = "root";
    };
    io = {
      hostname = "io";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.io;
      };
    };
    rog = {
      hostname = "rog";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.rog;
      };
    };
    homesv = {
      hostname = "homesv";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.homesv;
      };
      sshOpts = ["-i" "/etc/ssh/ssh_host_ed25519_key"];
      sshUser = "root";
    };
    kiiro = {
      hostname = "kiiro";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.kiiro;
      };
    };
    tosh = {
      hostname = "tosh";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.tosh;
      };
    };
  };
}
