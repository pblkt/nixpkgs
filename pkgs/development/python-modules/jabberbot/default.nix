{ stdenv, buildPythonPackage, isPy3k, fetchPypi, xmpppy }:

buildPythonPackage rec {
  pname = "jabberbot";
  version = "0.16";

  disabled = isPy3k;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1qr7c5p9a0nzsvri1djnd5r3d7ilh2mdxvviqn1s2hcc70rha65d";
  };

  propagatedBuildInputs = [ xmpppy ];

  doCheck = false; # lol, it does not even specify dependencies properly

  meta = with stdenv.lib; {
    description = "A framework for writing Jabber/XMPP bots and services";
    homepage = "http://thp.io/2007/python-jabberbot/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mic92 ];
  };
}
