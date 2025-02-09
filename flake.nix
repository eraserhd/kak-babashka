{
  description = "Evaluate babashka expressions while editing any file in Kakoune";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        kak-babashka = pkgs.callPackage ./derivation.nix {};
      in {
        packages = {
          default = kak-babashka;
          inherit kak-babashka;
        };
        checks = {
          test = pkgs.runCommandNoCC "kak-babashka-test" {} ''
            mkdir -p $out
            : ${kak-babashka}
          '';
        };
    })) // {
      overlays.default = final: prev: {
        kakounePlugins = prev.kakounePlugins // {
          kak-babashka = prev.callPackage ./derivation.nix {};
        };
      };
    };
}
