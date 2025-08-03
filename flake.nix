{
  description = "Compass - a Safari tab switcher for terminal written in Nushell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.stdenv.mkDerivation {
          pname = "compass";
          version = "0.1.0";

          src = ./.;

          buildInputs = [ nixpkgs.legacyPackages.${system}.nushell ];

          installPhase = ''
            mkdir -p $out/bin
            cp compass.nu $out/bin/ass
            chmod +x $out/bin/ass
          '';
        };
      });
    };
}
