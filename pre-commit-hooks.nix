{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem.pre-commit = {
    check.enable = false;

    settings.hooks = {
      alejandra.enable = true;
      prettier.enable = true;
      shellcheck.enable = true;
    };
  };
}
