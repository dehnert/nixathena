{
  description = "MIT Athena packaging for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      legacyPackages = forAllSystems (system: let
        pkgs = import nixpkgs { inherit system; };
      in (import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
      }) // rec {
        # This lets you pick the driver function
        test-infra = {
	  metaStandardTest = pkgs.callPackage ./test/meta-standard.nix { inherit self system; };
        };
        # This is what should actually get run
        test = {
          # `nix run '.#test.meta-standard'` to run this test
          # It requires network (for hesiod and AFS access), so we can't run
          # it in `checks` and need to explicitly choose `.driver` -- the
          # default apparently blocks network.
          meta-standard = test-infra.metaStandardTest.driver;
        };
      });
      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});


      checks = forAllSystems (system: let
	  pkgs = nixpkgs.legacyPackages.${system};
        in {
          # Add things here if we ever get anything that doesn't need network
        }
      );
    };
}
