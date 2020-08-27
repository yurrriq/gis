{ ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.gap = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        cargo
        gap-full
        git
        gnumake
        rlwrap
        (
          texlive.combine {
            inherit (texlive) scheme-small
              enumitem
              latexmk
              rsfs;
          }
        )
      ];
    };
  };
}
