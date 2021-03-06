{ stdenv, lib, fetchFromGitHub, cmake }:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation rec {
  pname = "oneDNN";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${version}";
    sha256 = "0w2rgr3zgk7a3cql12dpddyhz2isyqqaks4vm8p45y426pd5m64b";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  # The test driver doesn't add an RPath to the build libdir
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/src
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/src
  '';

  # The cmake install gets tripped up and installs a nix tree into $out, in
  # addition to the correct install; clean it up.
  postInstall = ''
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
