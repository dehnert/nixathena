{ stdenv, pkgs, lib, fetchFromGitHub,
  autoreconfHook, autoconf, automake, pkg-config,
  libidn,
}:

stdenv.mkDerivation rec {
  pname = "hesiod";
  version = "3.2.1-nix1";
  src = fetchFromGitHub {
    owner = "achernya";
    repo = "hesiod";
    rev = "39b21dac9bc6473365de04d94be0da94941c7c73";
    hash = "sha256-nDZEOR5W4nRFbOdEh+qyMYQquNHyNR4oKrj8WhbKeno=";
  };

  buildInputs = [
    autoreconfHook
    libidn
  ];
}
