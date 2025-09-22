{ lib, pkgs, config, options, ...
}:

{
  # Import each module that doesn't have side-effects, and merely defines some settings
  # (which should be every module)
  imports = [
    ./config/krb5.nix
    ./services/pyhesiodfs.nix
    ./services/discussd.nix
    ./services/remctld.nix
    ./meta/standard.nix
  ];
}
