{
  description = "Replicated application collaboration template";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            kubernetes-helm
            yq-go
            jq
            editorconfig-checker
          ];

          shellHook = ''
            echo "Replicated dev shell ready"
            echo "  helm: $(helm version --short 2>/dev/null || echo 'not available')"
            echo "  yq: $(yq --version 2>/dev/null || echo 'not available')"
            echo "  jq: $(jq --version 2>/dev/null || echo 'not available')"
            echo ""
            echo "Run 'make lint' to validate your changes"
          '';
        };
      });
}
