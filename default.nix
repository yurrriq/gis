{ pkgs ? import ./nix }:
{
  idris = pkgs.stdenv.mkDerivation {
    pname = "gis";
    version = (builtins.fromTOML (builtins.readFile ./elba.toml)).package.version;
    src = pkgs.nix-gitignore.gitignoreSource [ ".git/" "docs/" "lib/" "tst/" ] ./.;

    nativeBuildInputs = with pkgs; [
      elba
      (
        idrisPackages.with-packages
          (
            with idrisPackages; [
              contrib
              specdris
            ]
          )
      )
    ];

    buildPhase = ''
      elba build --offline
    '';

    # FIXME
    dontCheck = true;
    checkPhase = ''
      elba test
    '';

    installPhase = ''
      install -dm755 "$out"
      cp -rv target/lib "$out"/lib
    '';
  };
}
