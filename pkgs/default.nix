# https://nix.dev/tutorials/packaging-existing-software#building-with-nix-build
# default.nix
final: prev:
let
  inherit (final) callPackage;
in
{
  debathena-aclocal = callPackage ./aclocal.nix { };
  discuss = callPackage ./discuss.nix { };
  hesiod = callPackage ./hesiod.nix { };
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: let
      inherit (python-final) callPackage;
    in {
      python-discuss = callPackage ./python-discuss.nix { };
      python-afs = callPackage ./python-afs.nix { };
      python-hesiod = callPackage ./python-hesiod.nix { };
      locker-support = callPackage ./locker-support.nix { };
    })
  ];
  pyhesiodfs = callPackage ./pyhesiodfs.nix { };
  remctl = callPackage ./remctl.nix { };
  moira = callPackage ./moira.nix { };
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
