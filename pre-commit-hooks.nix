{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem.pre-commit = {
    check.enable = true;

    settings.hooks = {
      alejandra.enable = true;
      prettier.enable = true;
      shellcheck.enable = true;
    };
  };
}
