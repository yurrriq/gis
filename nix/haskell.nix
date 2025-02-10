{ ... }:

{
  flake.overlays.haskell = _final: prev: {
    haskellPackages = prev.haskellPackages.override {
      overrides = _hfinal: hprev: {
        acts = hprev.callCabal2nix "acts"
          (prev.fetchFromGitHub {
            owner = "sheaf";
            repo = "acts";
            rev = "3588191d44771fcd9f86e664283c453081750a07"; # v0.3.1.2
            hash = "sha256-2QaMRl8Fg6QnrAVkQesIMXeKg2B6XMtAMSAWr/0X8LQ=";
          })
          { };
        typelits-witnesses =
          prev.haskell.lib.markUnbroken hprev.typelits-witnesses;
      };
    };
  };

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
