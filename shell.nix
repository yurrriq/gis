{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; (
    [
      cargo
      gap-full
      git
      gnumake
      nixpkgs-fmt
      niv
      rlwrap
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
