{ stdenv, pkgs, lib, fetchFromGitHub,
  python3Packages, buildPythonPackage, setuptools,
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

  build-system = [
    setuptools
  ];

  buildInputs = [
    hesiod
  ];

  nativeBuildInputs = [
    python3Packages.cython
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
