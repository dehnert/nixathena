{ stdenv, pkgs, lib, fetchFromGitHub, autoreconfHook, debathena-aclocal, pkg-config, }:

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
    pkgs.krb5
    pkgs.e2fsprogs  # ss_perror
    pkgs.yacc
    pkgs.nettools
    pkg-config	# needed by debathena-aclocal
    debathena-aclocal
  ];
  nativeBuildInputs = [
  ];

  #configureFlags = ["--without-krb4" "--with-krb5" "--with-zephyr"];
  configureFlags = ["--without-krb4" "--with-krb5" "--without-zephyr"];
}
