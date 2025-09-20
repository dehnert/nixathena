{ stdenv, pkgs, lib,
  fetchFromGitHub, autoreconfHook, debathena-aclocal, pkg-config,
  libkrb5
}:

let
  fs = lib.fileset;
in stdenv.mkDerivation {
  pname = "discuss";
  version = "10.0.17";

  src = fetchFromGitHub {
    owner = "mit-athena";
    repo = "discuss";
    rev = "10.0.17";
    hash = "sha256-0WPz6OeeIAd/c8zUD00f0gDhYwO3ll9qPENxqPTjPhk=";
  };

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-return-mismatch";
  };

  meta = with lib; {
    description = "Project Athena forum system";
    homepage = "https://github.com/mit-athena/discuss";
    platforms = platforms.linux;
  };

  patchPhase = ''
  sed -ie 's#/bin/echo#echo#' edsc/newvers.sh
  '';

  buildInputs = [
    autoreconfHook
    libkrb5
    pkgs.e2fsprogs.dev # ss_perror library function
    pkgs.bison
    pkgs.nettools
    pkg-config	# needed by debathena-aclocal
    debathena-aclocal
  ];
  nativeBuildInputs = [
    # mk_cmds script
    # Moved to .scripts output in nixpkgs commit e58c9e7dd621a7d7 (25.11)
    (if pkgs.e2fsprogs ? scripts then pkgs.e2fsprogs.scripts else pkgs.e2fsprogs)
  ];

  #configureFlags = ["--without-krb4" "--with-krb5" "--with-zephyr"];
  configureFlags = [
    "--without-krb4" "--with-krb5" "--without-zephyr"
  ];
  preConfigure = ''
  configureFlagsArray+=(
    "CFLAGS=-DDSC_SETUP=\\\"$out/bin/dsc_setup\\\""
  )
  '';
}
