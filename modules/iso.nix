{pkgs, ...}:
# my own installer
{
  # kernel
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
