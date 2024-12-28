{
  description = "Zen browser's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      applySystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      eachSystem = f: applySystems (system: f nixpkgs.legacyPackages.${system});

      treefmtEval = eachSystem (
        pkgs:
        treefmt-nix.lib.evalModule pkgs {
          programs.nixfmt.enable = true;
        }
      );
    in
    {
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      packages = eachSystem (pkgs: {
        default = self.packages.${pkgs.system}.zen-browser;

        zen-browser = pkgs.callPackage ./default.nix { };
      });
    };
}
