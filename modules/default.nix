{
  # Add your NixOS modules here
  # Don't forget that nixathena.modules.whatever also needs to be in the
  # `modules = [ ... ]` list of your config to actually process these.
  discussd = ./discussd.nix;
  remctld = ./remctld.nix;
  pyhesiodfs = ./pyhesiodfs.nix;
}
