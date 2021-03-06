{ stdenv, fetchurl, ncurses, gettext, python3, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "calcurse-${version}";
  version = "4.3.0";

  src = fetchurl {
    url = "http://calcurse.org/files/${name}.tar.gz";
    sha256 = "16jzg0nasnxdlz23i121x41pq5kbxmjzk52c5d863rg117fc7v1i";
  };

  buildInputs = [ ncurses gettext python3 ];
  nativeBuildInputs = [ makeWrapper ];

  # Build Python environment with httplib2 for calcurse-caldav
  pythonEnv = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.httplib2 ];
  };
  propagatedBuildInputs = [ pythonEnv ];

  postInstall = ''
    substituteInPlace $out/bin/calcurse-caldav --replace /usr/bin/python3 ${pythonEnv}/bin/python3
  '';

  meta = with stdenv.lib; {
    description = "A calendar and scheduling application for the command line";
    longDescription = ''
      calcurse is a calendar and scheduling application for the command line. It helps
      keep track of events, appointments and everyday tasks. A configurable notification
      system reminds users of upcoming deadlines, the curses based interface can be
      customized to suit user needs and a very powerful set of command line options can
      be used to filter and format appointments, making it suitable for use in scripts.
    '';
    homepage = http://calcurse.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
