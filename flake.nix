{
  description = "Zen browser's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];

    forAllSystems = function:
      nixpkgs.lib.genAttrs supportedSystems (
        system: function (import nixpkgs {inherit system;})
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: {
      default = self.packages.${pkgs.system}.zen-browser;

      zen-browser = pkgs.callPackage ./default.nix {};
    });
  };
}
