{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; (
    [
      cargo
      git
      gnumake
      nixpkgs-fmt
      niv
      (texlive.combine {
        inherit (texlive) scheme-small
          enumitem
          latexmk
          rsfs;
      })
    ]
  ) ++ (
    with python3Packages; [
      pre-commit
    ]
  ) ++ (import ./. { inherit pkgs; }).idris.nativeBuildInputs;
}
