{
  description = "Nix flake based OCaml dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      ocamlinit = pkgs.writeText "ocamlinit" ''
        #require "base";;
        open Base;;
      '';

      ocamlPkgs = with pkgs.ocamlPackages; [
        findlib
        base
        core
        merlin
        ocaml-lsp
        odoc
        utop
        ounit2
      ];
    in
    {
      devShell = pkgs.mkShell {
        name = "ocaml-flake";

        buildInputs = with pkgs; [
          ocaml
          dune_3
          ocamlformat
        ] ++ ocamlPkgs;

        shellHook = ''
          alias utop="utop -init ${ocamlinit}"
          alias ocaml="ocaml -init ${ocamlinit}"
          ls
        '';
      };
    });
}
