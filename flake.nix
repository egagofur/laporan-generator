{
  description = "Laporan Generator - development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex = pkgs.texlive.withPackages (ps: [
          ps.collection-basic
          ps.collection-latex
          ps.collection-latexrecommended
          ps.collection-latexextra
          ps.collection-fontsrecommended
          ps.collection-langother
        ]);
      in {
        devShells.default = pkgs.mkShell {
          name = "laporan-generator";
          packages = [
            pkgs.pandoc
            tex
            pkgs.imagemagick
            pkgs.gnumake
            pkgs.coreutils
            pkgs.inotify-tools
            pkgs.xdg-utils
            pkgs.poppler-utils
            pkgs.haskellPackages.pandoc-crossref
            pkgs.shellcheck
            pkgs.typst
          ];
        };
      });
}
