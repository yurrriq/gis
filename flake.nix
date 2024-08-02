{
  description = "David Lewin's Generalized Interval Systems";

  inputs = {
    emacs-overlay = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:nix-community/emacs-overlay";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:cachix/git-hooks.nix";
    };
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  nixConfig = {
    commit-lockfile-summary = "build(deps): nix flake update";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
        ./nix/emacs.nix
        ./nix/haskell.nix
      ];

      systems = [
        "x86_64-linux"
      ];

      flake.overlays.default =
        let
          inherit (inputs.nixpkgs) lib;
        in
        lib.composeManyExtensions
          (lib.attrValues
            (lib.filterAttrs (name: _: name != "default") self.overlays));

      # FIXME: v2 works differently, I guess.
      flake.overlays.treefmt = _final: prev: {
        treefmt = prev.treefmt1;
      };

      perSystem = { config, pkgs, self', system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          overlays = [
            inputs.emacs-overlay.overlay
            self.overlays.default
          ];
          inherit system;
        };

        devShells = {
          default = pkgs.mkShell {
            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = [
                (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
              ];
            };

            inputsFrom = [
              config.pre-commit.devShell
              self'.devShells.emacs
              self'.devShells.haskell
            ];
          };
        };

        pre-commit.settings.hooks = {
          convco.enable = true;
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ./flake.nix;
          programs = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
          };
        };
      };
    };
}
