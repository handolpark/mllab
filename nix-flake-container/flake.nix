{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        pkgsAarch64Multiplatform = pkgs.pkgsCross.aarch64-multiplatform;
        buildImageAarch64Multiplatform = pkgs.dockerTools.buildImage {
          name = "hello-docker";
          config = {
            Cmd = [ "${pkgsAarch64Multiplatform.hello}/bin/hello" ];
          };
        };
      in {
        packages = rec {
          hello = pkgs.hello;
          imageAarch64Multiplatform = buildImageAarch64Multiplatform;
          default = hello;
        };
      });
}
