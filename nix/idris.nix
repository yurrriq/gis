{ ... }:

{
  perSystem = { pkgs, self', ... }: {
    devShells.idris = pkgs.mkShell {
      inputsFrom = [
        self'.packages.idris-gis
      ];
    };

    packages = {
      elba = pkgs.callPackage ./pkgs/elba { };

      idris-gis = pkgs.stdenv.mkDerivation {
        pname = "gis";
        version = (builtins.fromTOML (builtins.readFile ../elba.toml)).package.version;
        src = pkgs.nix-gitignore.gitignoreSource [ ".git/" "docs/" "lib/" "tst/" ] ../.;

        nativeBuildInputs = with pkgs; [
          self'.packages.elba
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

        checkPhase = ''
          elba test
        '';

        installPhase = ''
          install -dm755 "$out"
          cp -rv target/lib "$out"/lib
        '';
      };
    };

    treefmt = {
      programs = {
        hlint.enable = true;
        ormolu.enable = true;
      };
    };
  };
}
