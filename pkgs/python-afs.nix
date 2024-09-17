{ stdenv, pkgs, lib, fetchFromGitHub, buildPythonPackage, setuptools, python3,
  openafs, krb5, }:

let
  fs = lib.fileset;
in buildPythonPackage {
  pname = "python-afs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dehnert";
    repo = "python-afs";
    rev = "2a12421d4b94fbfecf6ea3cec459848a651f6be1"; # nix branch
    hash = "sha256-5tiABlKD3Vbb+fSrxVcZmqqi0ArBEwbJDhslk/r/QGs=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    openafs
    krb5
  ];

  nativeBuildInputs = [
    python3.pkgs.cython
    python3.pkgs.nose
  ];

  pythonImportsCheck = [
    "afs"
  ];

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
