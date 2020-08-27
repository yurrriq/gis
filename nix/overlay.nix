_: pkgs: rec {

  inherit (import (import ./sources.nix).niv { }) niv;

}
