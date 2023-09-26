{
  lib,
  theme,
  ...
}: {
  specialisation = {
    light = {
      inheritParentConfig = true;
      configuration._module.args.theme = lib.mkForce (theme // {variant = lib.mkForce "light";});
    };
    dark = {
      inheritParentConfig = true;
      configuration._module.args.theme = lib.mkForce (theme // {variant = lib.mkForce "dark";});
    };
  };
}
