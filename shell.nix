{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; (
    [
      cargo
      elba
      gap-full
      git
      gnumake
      (with idrisPackages; with-packages [ contrib ])
      nixpkgs-fmt
      niv
      rlwrap
      (texlive.combine {
        inherit (texlive) scheme-small
          enumitem
          latexmk;
      })
    ]
  ) ++ (
    with pythonPackages; [
      pre-commit
    ]
  );
}
