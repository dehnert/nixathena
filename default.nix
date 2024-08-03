# https://nix.dev/tutorials/packaging-existing-software#building-with-nix-build
# default.nix
{ dockerName ? "ghcr.io/dehnert/formationbot-rs/discord-bot", dockerTag ? "test" } :
let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
  debathena-aclocal = pkgs.callPackage ./aclocal.nix { };
in
{
  discuss = pkgs.callPackage ./discuss.nix { debathena-aclocal=debathena-aclocal; };
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
