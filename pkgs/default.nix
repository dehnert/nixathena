# https://nix.dev/tutorials/packaging-existing-software#building-with-nix-build
# default.nix
{ pkgs }:
let
in rec
{
  debathena-aclocal = pkgs.callPackage ./aclocal.nix { };
  discuss = pkgs.callPackage ./discuss.nix { inherit debathena-aclocal; };
  python-discuss = ps: ps.callPackage ./python-discuss.nix { };
  python-afs = ps: ps.callPackage ./python-afs.nix { };
  hesiod = pkgs.callPackage ./hesiod.nix { };
  python-hesiod = ps: ps.callPackage ./python-hesiod.nix { inherit hesiod; };
  locker-support = ps: ps.callPackage ./locker-support.nix { inherit python-afs python-hesiod; };
  pyhesiodfs = pkgs.callPackage ./pyhesiodfs.nix { inherit python-hesiod locker-support; };
  remctl = pkgs.callPackage ./remctl.nix { };
  # https://ryantm.github.io/nixpkgs/builders/images/dockertools/
#   docker = pkgs.dockerTools.buildLayeredImage {
#     name = "${dockerName}";
#     tag = "${dockerTag}";
#     config = {
#       # See https://github.com/opencontainers/image-spec/blob/main/config.md
#       # for semantics
#       Cmd = "${formationbot}/bin/discord-bot";
#       WorkingDir = "/config/";
#       Volumes = { "/config/" = { }; };
#     };
#   };
}

# Running `nix-build default.nix` will run the build and spit out a path
# Running `nix-build default.nix -A docker` will make `result` point to the
# Docker image. Similarly for `-A formationbot`. Without `-A`, we get
# `result` and `result-2`.
