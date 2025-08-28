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

  patches = [
    # Required for automake 1.17+ compatibility
    # See https://github.com/rra/remctl/issues/35
    # This can probably be removed when updating beyond 3.18
    (builtins.fetchurl {
      url = "https://github.com/rra/remctl/commit/cad43fe0472db09b3f267f0c212d34a23360dc05.patch";
      sha256 = "sha256:1l8s77h2w0ppiwa1rcbqgbwsh4jg0jpnjbm636a6qscgwmxy2saz";
    })
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
