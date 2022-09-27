inputs: {
  nodes = with inputs.deploy-rs.lib.x86_64-linux; {
    io = {
      hostname = "io";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.io;
      };
    };
    kiiro = {
      hostname = "kiiro";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.kiiro;
      };
    };
  };
}
