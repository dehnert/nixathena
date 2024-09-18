{ stdenv, pkgs, lib, fetchFromGitHub,
  autoreconfHook, autoconf, automake, pkg-config,
  libkrb5, libevent, pcre2, systemdLibs,
  python3, perl,
}:

stdenv.mkDerivation rec {
  pname = "remctl";
  version = "3.18";
  src = fetchFromGitHub {
    owner = "rra";
    repo = "remctl";
    rev = "release/3.18";
    hash = "sha256-4KzNhFswNTwcXrDBAfRyr502zwRQ3FACV8gDfBm7M0A=";
  };

  buildInputs = [
    autoreconfHook
    autoconf
    automake
    pkg-config
    libkrb5
    libevent
    pcre2
    systemdLibs
    python3 # python bindings
    perl    # build man pages
  ];

  # This runs autoreconf twice, but autoreconfHook sets up the autoconf
  # macros and ./bootstrap makes the man pages, so it's hard to skip
  # either.
  preConfigure = ''
  echo Running bootstrap
  ./bootstrap
  echo Finished bootstrap
  configureFlagsArray+=(
    "--with-systemdsystemunitdir=$out/etc/systemd/system"
  )
  '';
  postInstall = ''
  cp examples/remctl.conf $out/etc/
  '';
}
