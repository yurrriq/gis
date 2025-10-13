{ ... }:

{
  perSystem = { lib, pkgs, self', ... }: {
    devShells.haskell = pkgs.mkShell {
      inputsFrom = [
        self'.packages.GIS.env
      ];

      nativeBuildInputs = with pkgs.haskellPackages; [
        cabal-install
        ghc
        ghcid
        haskell-language-server
        hlint
        hpack
        ormolu
        pointfree
      ];
    };

    packages = {
      default = self'.packages.GIS;

      GIS =
        let
          inherit (pkgs.haskell.lib)
            overrideCabal
            ;
          inherit (pkgs.haskellPackages)
            callCabal2nix
            ;
          src = lib.fileset.toSource {
            root = ../.;
            fileset = lib.fileset.unions [
              ../LICENSE
              ../VERSION
              ../cabal.project
              ../package.yaml
              ../src
              ../test
            ];
          };
        in
        overrideCabal (callCabal2nix "GIS" src.outPath { }) {
          haddockFlags = [
            "--html-location='https://hackage.haskell.org/package/$pkgid/docs/'"
          ];
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
