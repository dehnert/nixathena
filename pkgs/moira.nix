{ stdenv, pkgs, lib,
  fetchFromGitHub, autoreconfHook, pkg-config,
  libkrb5, openafs, readline, ncurses, openssl, termcap,
  hesiod,
}:

let
  fs = lib.fileset;
in stdenv.mkDerivation rec {
  pname = "moira";
  version = "4.2.4.0";

  # Ideally we'd use the github.mit.edu version, but that requires auth
  # https://github.mit.edu/ops/moira
  src = fetchFromGitHub {
    owner = "mit-athena";
    repo = "moira";
    rev = "${version}";
    hash = "sha256-joO8n3jocmL/JqOkt47jnN3dvmtoZGwk+Ixd+ChDcss=";
  };
  sourceRoot = "source/moira";

  meta = with lib; {
    description = "Athena Service Management system";
    homepage = "https://github.com/mit-athena/moira";
    platforms = platforms.linux;
  };

  buildInputs = [
    autoreconfHook
    libkrb5
    readline
    ncurses
    openssl
    openafs
    termcap
    hesiod
  ];
  nativeBuildInputs = [
  ];

  # I don't understand why upstream is happy with the existing Makefile.in, but
  # it doesn't build without this patch for me (it looks like the files are in
  # .libs but not found). It does feel more correct to pass in $(OBJS) than to
  # just assume that the object files are $(TARGET).o -- note that e.g.
  # `blanche` already looks like this, so there's inconsistency between files.
  patchPhase = ''
  sed -ie 's#$(LDFLAGS) $@.o $(LIBS)#$(LDFLAGS) $(OBJS) $(LIBS)#' clients/*/Makefile.in
  '';

  #configureFlags = ["--without-krb4" "--with-krb5" "--with-zephyr"];
  configureFlags = [
    "--without-krb4" "--with-krb5" "--without-zephyr" "--with-hesiod" "--with-afs" "--with-readline" "--with-com_err=${libkrb5.out}"
  ];
}
