# ComfyUI (Docker + NVIDIA GPU)

Dockerized [ComfyUI](https://github.com/comfyanonymous/ComfyUI) based on `nvidia/cuda:13.0.3-cudnn-runtime-ubuntu24.04` with PyTorch cu130.

## Requirements

- Linux with NVIDIA driver (check with `nvidia-smi`)
- Docker + Docker Compose
- [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for GPU passthrough

## Run

```bash
cp .env.example .env   # if present; otherwise use your existing .env
docker compose up -d --build
```

The UI is available at `http://localhost:8188`.

Logs:

```bash
docker compose logs -f comfyui
```

Stop:

```bash
docker compose down
```

## Configuration

Variables in `.env`:

| Variable            | Default          | Description                                           |
|---------------------|------------------|-------------------------------------------------------|
| `TZ`                | `America/New_York` | Container timezone                                  |
| `COMFYUI_HOST`      | `0.0.0.0`        | Listen address                                        |
| `COMFYUI_PORT`      | `8188`           | ComfyUI port                                          |
| `COMFYUI_EXTRA_ARGS`| `""`             | Extra `main.py` flags (`--lowvram`, `--novram`, `--cpu`) |

## Volumes

Host directories are mounted into the container (created automatically):

| Host            | Container                   | Purpose                       |
|-----------------|-----------------------------|-------------------------------|
| `./models`      | `/opt/ComfyUI/models`       | Checkpoints, LoRA, VAE, etc.  |
| `./custom_nodes`| `/opt/ComfyUI/custom_nodes` | Custom nodes                   |
| `./input`       | `/opt/ComfyUI/input`        | Input images                   |
| `./output`      | `/opt/ComfyUI/output`       | Generation outputs             |
| `./user`        | `/opt/ComfyUI/user`         | User workflows                 |
| `./logs`        | `/opt/ComfyUI/logs`         | Logs                           |

## Install Without Docker

See [INSTALL.md](INSTALL.md).
