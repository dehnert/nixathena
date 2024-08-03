{ stdenv, pkgs, lib, fetchFromGitHub, pkg-config, }:

let
  fs = lib.fileset;
in stdenv.mkDerivation {
  pname = "debathena-aclocal";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "mit-athena";
    repo = "aclocal";
    rev = "1.1.4";
    hash = "sha256-KGbEzxxi81fTFgNYtWX+z12PNgr36pZyNz2BVwGYfIo=";
  };

  buildPhase = ''
  mkdir $out
  mkdir $out/share
  cp -r aclocal $out/share/aclocal
  '';

  meta = with lib; {
    description = "Project Athena aclocal files";
    homepage = "https://github.com/mit-athena/aclocal";
    platforms = platforms.linux;
  };

  buildInputs = [
    pkg-config
  ];
  nativeBuildInputs = [
  ];
}
