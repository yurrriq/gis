{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; (
    [
      cargo
      elba
      git
      gnumake
      (with idrisPackages; with-packages [ contrib ])
      nixpkgs-fmt
      niv
      rlwrap
    ]
  ) ++ (
    with pythonPackages; [
      pre-commit
    ]
  );
}
