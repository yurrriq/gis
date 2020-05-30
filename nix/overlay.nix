_: pkgs: rec {

  elba = pkgs.callPackage ./pkgs/elba {};

  inherit (import (import ./sources.nix).niv { }) niv;

}
