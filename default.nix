# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  athena-pkgs = import ./pkgs { inherit pkgs; };
  athena-python = with athena-pkgs; [ python-discuss python-afs python-hesiod locker-support ];
  athena-python3 = (pkgs.python3.withPackages (ps: (map (pkg: pkg ps) athena-python)));
in
{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  #overlays = import ./overlays; # nixpkgs overlays
  overlays = {
    # This doesn't get run????
    additions = final: prev: {athena-pkgs=builtins.trace "evaluating the overlay" athena-pkgs;};
  };

  inherit athena-pkgs;
  # linkFarmFromDrvs is undocumented, but the source is at
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix#L578
  default = pkgs.linkFarmFromDrvs "nixathena-pkgs" (with athena-pkgs; [ discuss pyhesiodfs remctl athena-python3 ]);
  debathena-aclocal = athena-pkgs.debathena-aclocal;
  discuss = athena-pkgs.discuss;
  python-discuss = athena-pkgs.python-discuss;
  python-afs = athena-pkgs.python-afs;
  python-hesiod = athena-pkgs.python-hesiod;
  pyhesiodfs = athena-pkgs.pyhesiodfs;
  remctl = athena-pkgs.remctl;
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
  athena-python3 = athena-python3;
}
