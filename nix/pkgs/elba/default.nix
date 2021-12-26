{ lib, stdenv, fetchurl, glibc, zlib }:

assert !stdenv.targetPlatform.isMusl;

stdenv.mkDerivation rec {
  pname = "elba";
  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/elba/elba/releases/download/${version}/elba-${version}-${stdenv.targetPlatform.config}.tar.gz";
    sha256 = "1j1zyba21ygcvd3s5zr5zl43cwvcvjf359hcgvcqyqz4fpc67ih9";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -dm755 "$out/bin"
    install -m755 elba "$_"
  '';

  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ glibc zlib ]}" \
      $out/bin/elba
  '';

  meta = with lib; {
    description = "A package manager for Idris";
    inherit (src) homepage;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.linux;
  };
}
