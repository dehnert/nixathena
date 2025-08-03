{ stdenv, pkgs, lib, fetchFromGitHub,
  cython, buildPythonPackage, setuptools,
  hesiod,
}:

let
  fs = lib.fileset;
in buildPythonPackage {
  pname = "python-hesiod";
  version = "0.2.13";

  src = fetchFromGitHub {
    #owner = "mit-athena";
    owner = "macathena";
    repo = "python-hesiod";
    #rev = "master";
    rev = "python3";
    hash = "sha256-Lsq5LCQvEjL7Pga+LLpkTjYWBQM3VLmQ8LWVYI+Llkc=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  buildInputs = [
    hesiod
  ];

  nativeBuildInputs = [
    cython
  ];

  pythonImportsCheck = [
    "hesiod"
  ];

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
