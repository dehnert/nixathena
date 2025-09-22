{
  # Don't forget that nixathena.modules.whatever also needs to be in the
  # `modules = [ ... ]` list of your config to actually process these.

  # Enable the "standard" metapackage (clients, pyhesiodfs, etc.) by including
  # the `nixathena.meta.standard` module and then setting
  # `nixathena.meta.standard.enable = true;`

  options = ./options.nix;
  config = {
    krb5 = ./config/krb5.nix;
  };
  services = {
    discussd = ./services/discussd.nix;
    remctld = ./services/remctld.nix;
    pyhesiodfs = ./services/pyhesiodfs.nix;
  };
  meta = {
    standard = ./meta/standard.nix;
  };
}
