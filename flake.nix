{
  description = "Dev shell with uv and CUDA support for Python 3.12";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-gl-host = {
      url = "github:numtide/nix-gl-host";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-gl-host,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in
    {
      devShells.x86_64-linux.default =
        with pkgs;
        mkShell rec {

          packages = [
            cmake
            ninja
            cudaPackages.cudatoolkit
            cudaPackages.cuda_cudart
            cudaPackages.cuda_cupti
            cudaPackages.cuda_nvrtc
            cudaPackages.cuda_nvtx
            cudaPackages.cudnn
            cudaPackages.libcublas
            cudaPackages.libcufft
            cudaPackages.libcurand
            cudaPackages.libcusolver
            cudaPackages.libcusparse
            cudaPackages.libnvjitlink
            cudaPackages.nccl
            nix-gl-host.defaultPackage.x86_64-linux
            uv
            python312
            zlib
          ];

          shellHook = ''
            uv sync
            . .venv/bin/activate
            export LD_LIBRARY_PATH=$(nixglhost -p):$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH="${lib.makeLibraryPath packages}:$LD_LIBRARY_PATH"
            export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
            echo "Entering CUDA dev shell, python venv is ready and activated."
          '';
        };
    };
}
