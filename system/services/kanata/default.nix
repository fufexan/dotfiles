{
  # keyboard remapping
  services.kanata = {
    enable = true;

    keyboards.default.config = builtins.readFile (./. + "/main.kbd");
  };
}
