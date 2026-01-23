# nix-flake-cuda

Minimal Python + CUDA template powered by Nix flakes. Substituers are also configured so most packages are downloaded from cache instead of built locally.

## Requirements
- Nix with flakes enabled
- NVIDIA drivers (CUDA-capable GPU)

## Quick start
Enter the dev shell

```sh
nix develop
```

Run this to test CUDA availability in PyTorch:

```sh
uv run python -c "import torch; print(torch.cuda.is_available())"
# Expected output: True
```

Customize `flake.nix` and `pyproject.toml` to fit your project.

## Adding dependencies

To add depedencies just use `uv add <package>` command, running `nix develop` afterwards will run `uv sync` automatically to update the Nix environment.