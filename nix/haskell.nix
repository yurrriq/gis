{ ... }:

{
  perSystem = { pkgs, self', ... }: {
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

      GIS = pkgs.haskellPackages.callCabal2nix
        "GIS"
        (pkgs.nix-gitignore.gitignoreSource [ ] ../.)
        { };
    };

    treefmt = {
      programs = {
        hlint.enable = true;
        ormolu.enable = true;
      };
    };
  };
}
