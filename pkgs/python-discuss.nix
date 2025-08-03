{ stdenv, pkgs, lib, fetchFromGitHub, buildPythonPackage, setuptools, }:

let
  fs = lib.fileset;
in buildPythonPackage {
  pname = "python-discuss";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mit-athena";
    repo = "python-discuss";
    rev = "1.2";
    hash = "sha256-8/ew78oM39U+ibbQvYkCe0kzIBYgK2YznVWQiA7nWds=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "discuss"
    "discuss.client"
    "discuss.constants"
  ];

  #meta = with lib; {
  #  description = "Python library for Project Athena forum system";
  #  homepage = "https://github.com/mit-athena/python-discuss";
  #  platforms = platforms.linux;
  #};
}
