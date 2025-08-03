{ stdenv, pkgs, lib, fetchFromGitHub,
  python3Packages, buildPythonPackage, setuptools,
  python-afs, python-hesiod,
}:

# TODO: Also install binaries

let
  fs = lib.fileset;
in buildPythonPackage {
  pname = "locker-support";
  version = "10.4.7";

  src = fetchFromGitHub {
    owner = "mit-athena";
    repo = "locker-support";
    rev = "10.4.7";
    hash = "sha256-s/L6LbBcRdno1EFbTDeQg5CMV2uJLn7xaOQgpiFLOfQ=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [
    python-afs
    python-hesiod
  ];

  buildInputs = [
  ];

  nativeBuildInputs = [
  ];

  pythonImportsCheck = [
    "locker"
    "athdir"
  ];

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
