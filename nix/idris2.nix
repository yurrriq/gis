{ lib, ... }:

{
  perSystem = { pkgs, self', ... }: {
    devShells.idris2 = pkgs.mkShell {
      inputsFrom = [
        self'.packages.idris2-gis.withSource
      ];

      nativeBuildInputs = with pkgs.idris2Packages; [
        idris2Lsp
        pkgs.rlwrap
      ];
    };

    packages = {
      idris2-gis = (pkgs.idris2Packages.buildIdris {
        ipkgName = "idris2-gis";
        version = "0.1.0";
        src = lib.fileset.toSource {
          fileset = lib.fileset.unions [
            ../idris2-gis.ipkg
            ../idris2
          ];
          root = ../.;
        };

        idrisLibraries = with pkgs.idris2Packages; [
          idris2Api
          (
            buildIdris {
              ipkgName = "algebra";
              version = "2024-04-05";
              src = pkgs.fetchFromGitHub {
                owner = "stefan-hoeck";
                repo = "idris2-algebra";
                rev = "829f44b7fd961e3f0a7ad9174b395f97ebc33336";
                hash = "sha256-etsWqF07j/XBgfnlaA8pyF06BeoXqg7iViG0o09s4Zc=";
              };
              idrisLibraries = [ ];
            }
          )
        ];

        meta = with lib; {
          description = "Idris 2 implementation of David Lewin's GIS";
          homepage = "https://github.com/yurrriq/gis";
          license = licenses.mit;
          maintainers = with maintainers; [ yurrriq ];
          # TODO: mainProgram = "idris2-gis-tests";
        };
      }).library { };
    };
  };
}
