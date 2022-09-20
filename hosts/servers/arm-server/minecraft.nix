{pkgs, ...}: {
  services.minecraft-server = {
    enable = true;
    package = pkgs.minecraftServers.vanilla-1-19;
    eula = true;
    jvmOpts = "-Xms4092M -Xmx4092M
      -XX:+UseG1GC -XX:+CMSIncrementalPacing
      -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2
      -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
    openFirewall = true;
  };
}
