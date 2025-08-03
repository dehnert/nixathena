{ stdenv, pkgs, lib, fetchFromGitHub,
  cython, buildPythonPackage, setuptools,
  openafs, libkrb5,
}:

let
  fs = lib.fileset;
in buildPythonPackage {
  pname = "python-afs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "macathena";
    repo = "python-afs";
    rev = "300a92404859ed99a8d9db066b9526c363760e21"; # py3 branch
    hash = "sha256-pm3UCNqUKSzlfOk4jTenrg6PH8SMRgrRQE4uABXvXD0=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  buildInputs = [
    openafs
    libkrb5
  ];

  nativeBuildInputs = [
    cython
  ];

  pythonImportsCheck = [
    "afs"
  ];

  # The tests assume that we have AFS installed and working on the machine
  # (e.g., they access files in AFS, expect ThisCell to be set, etc.), so
  # skip them.
  # pythonImportsCheck is run regardless per
  # https://ryantm.github.io/nixpkgs/languages-frameworks/python/#using-pythonimportscheck
  doCheck = false;

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
