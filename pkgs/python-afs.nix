{ stdenv, pkgs, lib, fetchFromGitHub,
  cython, python, buildPythonPackage, setuptools,
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

  env = lib.optionalAttrs (python.pythonAtLeast "3.13") {
    # Workaround for https://github.com/mit-athena/python-afs/issues/6
    # Can probably be removed in 3.15 or maybe 3.14

    # Without this hack, Python and OpenAFS have competing lock.h files, and we
    # need OpenAFS's to win but Python's does win. Until Python 3.15 comes out,
    # we force OpenAFS's headers to come before Python's when building
    # python-afs. This is a little tricky, because Python's headers use -I by
    # default while OpenAFS's use -isystem, and -I headers all come before
    # -isystem ones. However, if we add Python headers with -isystem at the
    # start of the compiler command, Python's -I will be treated as a dup of a
    # system header, and Python's headers will be moved to the system section
    # of the search path. *However*, because they're at the *start* of the
    # search path, they'll still beat OpenAFS, so we need to also add -isystem
    # for OpenAFS at the start of the compiler command, so the relative order
    # among the system section is correct.

    NIX_CFLAGS_COMPILE="-isystem${openafs.dev}/include -isystem${python}/include/python${python.pythonVersion}";
    #NIX_DEBUG="1";
  };

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
