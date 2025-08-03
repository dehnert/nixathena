{ stdenv, pkgs, lib, fetchFromGitHub,   # general nix
  python3Packages,                      # nix python
  python-hesiod, locker-support,        # athena
}:

let
  fs = lib.fileset;
in python3Packages.buildPythonApplication {
  pname = "pyhesiodfs";
  version = "1.1";

  src = fetchFromGitHub {
    #owner = "mit-athena";
    owner = "dehnert";
    repo = "pyhesiodfs";
    rev = "master";
    hash = "sha256-5Y10agUgfPuJ7Mg8IR0ZMtgqMXmG8F+kTQyjXrBGnBk=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    fuse
    (python-hesiod python3Packages)
    (locker-support python3Packages)
    #(builtins.trace python-hesiod python-hesiod)
  ];

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
