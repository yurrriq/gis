{
  description = "A very basic flake";

  inputs = {
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
  };

  outputs = { self, emacs-overlay, flake-utils, nixpkgs }: {
    overlay = final: prev: {
      myEmacs = prev.emacsWithPackagesFromUsePackage {
        alwaysEnsure = true;
        config = ./emacs.el;
      };
    };
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        overlays = [
          emacs-overlay.overlay
          self.overlay
        ];
        inherit system;
      };
    in
    {
      defaultPackage =
        pkgs.haskell.lib.addBuildTools
          (
            pkgs.haskellPackages.callCabal2nix
              "GIS"
              (pkgs.nix-gitignore.gitignoreSource [ ] ./.)
              { }
          )
          (with pkgs.haskellPackages; [
            cabal-install
            ghc
            ghcid
            hlint
            hpack
            ormolu
            pointfree
          ]);

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          gitAndTools.pre-commit
          haskell-language-server
          myEmacs
          nixpkgs-fmt
          self.defaultPackage.${system}.env.nativeBuildInputs
        ];
      };

      packages.GIS = self.defaultPackage.${system};
    }
  );
}
